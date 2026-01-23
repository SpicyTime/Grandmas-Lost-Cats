extends Node

var ui_menus: Dictionary[Enums.MenuType, Control] = {}
var ui_overlays: Dictionary[Enums.OverlayType, Control] = {}

var active_overlays: Array[Control] = []
var active_overlay_types: Array[Enums.OverlayType] = []

var active_menu: Control = null
var active_menu_type: Enums.MenuType = Enums.MenuType.NONE

# Since this is an autoload we need a node to "attach" the ui to
func set_up_ui(canvas_layer: CanvasLayer) -> void:
	# Grabs the needed nodes, they should always be in this order
	var menus: Control = canvas_layer.get_child(0).get_child(0)
	var overlays: Control = canvas_layer.get_child(0).get_child(1)
	
	# Sets up the menus
	for menu in menus.get_children():
		var menu_type: Enums.MenuType = _menu_type_from_name(menu.name)
		ui_menus[menu_type] = menu
		
	# Sets up the overlays
	for overlay in overlays.get_children():
		var overlay_type: Enums.OverlayType = _overlay_type_from_name(overlay.name)
		ui_overlays[overlay_type] = overlay


func show_overlay(overlay_type: Enums.OverlayType) -> void:
	var overlay: Control = ui_overlays[overlay_type]
	
	if overlay.has_method("handle_shown"):
		overlay.handle_shown()
	
	# Sets the variables to make it active and visible
	overlay.visible = true
	active_overlays.append(overlay)
	active_overlay_types.append(overlay_type)


func hide_overlay(overlay_type: Enums.OverlayType) -> void:
	var overlay: Control = ui_overlays[overlay_type]
	# Actually hides the overlay by removing it from the necessary arrays
	if overlay in active_overlays:
		if overlay.has_method("handle_exit"):
			overlay.handle_exit()
		# Sets the variables to make it inactive and hidden
		active_overlays.erase(overlay)
		active_overlay_types.erase(overlay_type)
		overlay.visible = false


func swap_menu(menu_type: Enums.MenuType) -> void:
	# Gets everything ready and returns to the actual game 
	if menu_type == Enums.MenuType.NONE:
		if active_menu:
			active_menu.visible = false
			active_menu = null
			active_menu_type = Enums.MenuType.NONE
			get_tree().paused = false
		return
	
	var menu: Control = ui_menus[menu_type]
	# Exits out of the old one if there was one
	if active_menu:
		if active_menu.has_method("handle_exit"):
			active_menu.handle_exit()
		active_menu.visible = false
	
	if menu.has_method("handle_entered"):
		menu.handle_entered()
	# Sets the variables to make it active and visible
	get_tree().paused = true
	active_menu = menu
	active_menu_type = menu_type
	active_menu.visible = true

# Gets the enum based off of the string name
func _menu_type_from_name(menu_name: String) -> Enums.MenuType:
	#match overlay_name:
	return Enums.MenuType.NONE

# Gets the enum based off of the string name
func _overlay_type_from_name(overlay_name: String) -> Enums.OverlayType:
	match overlay_name: 
		_:
			return Enums.OverlayType.DIALOGUE_UI

func add_dialog_box(dialog_box: DialogBox) -> void:
	ui_overlays[Enums.OverlayType.DIALOGUE_UI].add_child(dialog_box)
