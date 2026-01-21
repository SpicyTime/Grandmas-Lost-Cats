extends CanvasLayer
@onready var fade: ColorRect = $ColorRect
var fade_tween: Tween = null
var room_data: Array = []
func transition(new_data: Array) -> void:
	room_data = new_data
	# Turning the fade invisible effectively disables the transition
	if not fade.visible:
		_load_new_room()
		return
	# Sets the players velocity to zero to avoid them moving even 
	# when the player is not inputting a direction after transitioning.
	room_data[2][2] = Vector2.ZERO
	if fade_tween:
		fade_tween.kill()
	fade_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	# Makes sure that it runs even when the tree is paused
	fade_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	# Fades to black
	fade_tween.tween_property(fade, "color:a", 1.0, 0.2).connect("finished", _load_new_room) 
	# Fades from black right after
	fade_tween.chain().tween_property(fade, "color:a", 0.0, 0.4)
	get_tree().paused = true
	await fade_tween.finished
	get_tree().paused = false


func _load_new_room() -> void:
	get_parent().handle_room_swap(room_data)
