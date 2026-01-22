extends "res://world/rooms/base_room.gd"
var cat_sprite_lookup: Dictionary[int, Sprite2D] = {}
@onready var cats: Node2D = $Cats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.cat_found.connect(_turn_on_cat)
	for static_cat_sprite in cats.get_children():
		static_cat_sprite.visible = false
		cat_sprite_lookup[static_cat_sprite.id] = static_cat_sprite


func _turn_on_cat(cat_id: int) -> void:
	if cat_sprite_lookup.has(cat_id):
		cat_sprite_lookup[cat_id].visible = true
