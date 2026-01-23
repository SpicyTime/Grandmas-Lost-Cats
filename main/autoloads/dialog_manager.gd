extends Node
@onready var dialog_box_scene: PackedScene = preload("res://main/dialog system/dialog_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index: int = 0
var current_speaker_id: int = -1
var current_speaker_texture: Texture2D = null

var dialog_box: DialogBox = null
var dialog_box_position: Vector2 = Vector2.ZERO

var is_dialog_active: bool = false
var can_advance_line: bool = false
func _ready() -> void:
	SignalManager.finished_displaying_text.connect(_on_dialog_box_finished_displaying)


func start_dialog(lines: Array[String], speaker_id: int, speaker_texture: Texture2D) -> void:
	if is_dialog_active:
		return
	current_speaker_id = speaker_id
	current_speaker_texture = speaker_texture
	dialog_lines = lines
	_show_dialog_box()
	is_dialog_active = true
	SignalManager.disable_player.emit()


func _show_dialog_box() -> void:
	dialog_box = dialog_box_scene.instantiate()
	UiManager.add_dialog_box(dialog_box)
	#dialog_box.auto_advance_timer.connect("timeout", _advance_dialogue)
	#dialog_box.position = dialog_box_position
	dialog_box.set_offsets_preset(Control.PRESET_CENTER)
	dialog_box.set_speaker_id(current_speaker_id)
	dialog_box.set_speaker_texture(current_speaker_texture)
	dialog_box.display_text(dialog_lines[current_line_index])
	
	can_advance_line = false


func _on_dialog_box_finished_displaying() -> void:
	can_advance_line = true
	#dialog_box.auto_advance_timer.start(dialog_box.auto_advance_time) 


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog") and is_dialog_active:
		_advance_dialogue()


func _advance_dialogue() -> void:
	dialog_box.queue_free()
	current_line_index += 1
	if current_line_index >= dialog_lines.size():
		is_dialog_active = false
		current_line_index = 0
		SignalManager.dialog_finished.emit()
		return
	_show_dialog_box() 
