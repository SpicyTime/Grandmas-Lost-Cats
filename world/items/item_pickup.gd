class_name ItemPickup
extends RigidBody2D
@export var item_data: ItemData = null
@export var is_floating: bool = false
@onready var item_sprite: Sprite2D = $ItemSprite
func _ready() -> void:
	item_sprite.texture = item_data.item_texture
	freeze = is_floating


func handle_interact() -> void:
	# TO DO: 
	# 1. Play sound
	# 2. Play effects
	SignalManager.pickup_item.emit(item_data)
	queue_free()
