class_name DialogBox
extends MarginContainer

@onready var letter_display_timer: Timer = $LetterDisplayTimer
@onready var auto_advance_timer: Timer = $AutoAdvanceTimer
@onready var text_box: MarginContainer = $TextBox
@onready var label: Label = text_box.get_child(0)
@onready var speaker_container: MarginContainer = $SpeakerContainer
@onready var speaker_sprite: TextureRect = speaker_container.get_child(0)
const MAX_WIDTH: int = 250

var text: String = ""
var letter_index: int = 0

var letter_time: float = 0.03
var space_time: float = 0.06
var punctuation_time: float = 0.2

var current_speaker_id: int = 0
#var auto_advance_time: float = 4.0


func set_speaker_id(new_id: int) -> void:
	current_speaker_id = new_id
	_handle_speaker_id_changed(new_id)


func set_speaker_texture(texture: Texture2D) -> void:
	if current_speaker_id != Constants.NO_SPEAKER_ID:
		speaker_sprite.texture = texture


func display_text(text_to_display: String) -> void:
	text = text_to_display
	label.text = text_to_display 
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # Wait for x resize
		await resized # Wait for y resize 
		#custom_minimum_size.y = size.y
	_align_by_speaker(current_speaker_id)
	label.text = ""
	_display_letter()


func _display_letter():
	label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		SignalManager.finished_displaying_text.emit()
		return
	
	match text[letter_index]: 
		"!", ".", ",", "?":
			letter_display_timer.start(punctuation_time)
		" ":
			letter_display_timer.start(space_time)
		_:
			letter_display_timer.start(letter_time)

# This has to be a separate function so it runs after all the resizing
func _align_by_speaker(id: int) -> void:
	set_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	set_anchors_preset(Control.PRESET_CENTER_BOTTOM) 
	if id == Constants.NO_SPEAKER_ID:
		text_box.add_theme_constant_override("margin_left", 8)


func _handle_speaker_id_changed(speaker_id: int) -> void:
	if speaker_id == Constants.NO_SPEAKER_ID:
		speaker_container.queue_free()
	elif speaker_id != Constants.PLAYER_SPEAKER_ID:
		speaker_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
