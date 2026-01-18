class_name ItemStrategy
extends Resource
@export var item_name: String = ""
@export var item_texture: Texture2D = null
@export var item_priority: int = 0

func handle_pickup(player_node: CharacterBody2D) -> void:
	pass
