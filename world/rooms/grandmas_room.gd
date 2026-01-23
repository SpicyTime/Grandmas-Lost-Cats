extends "res://world/rooms/base_room.gd"
var cat_sprite_lookup: Dictionary[int, Sprite2D] = {}
var speaker_texture: Texture2D = preload("res://icon.svg")
@onready var cats: Node2D = $Cats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.cat_found.connect(_turn_on_cat)
	for static_cat_sprite in cats.get_children():
		static_cat_sprite.visible = false
		cat_sprite_lookup[static_cat_sprite.id] = static_cat_sprite
	await get_tree().create_timer(1.0).timeout
	DialogManager.start_dialog(["Hello?", "How are you doing today?"], Constants.PLAYER_SPEAKER_ID, speaker_texture)


func _turn_on_cat(cat_id: int) -> void:
	if cat_sprite_lookup.has(cat_id):
		cat_sprite_lookup[cat_id].visible = true
