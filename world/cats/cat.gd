class_name Cat
extends Node2D
@export var cat_name: String = ""
@export var description: String = ""
@export var texture: Texture2D = null
@export var id = 0
@onready var cat_sprite: Sprite2D = $CatSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.register_cat.emit(self)
	cat_sprite.texture = texture


func handle_interact() -> void:
	SignalManager.cat_found.emit(id)
	queue_free()
