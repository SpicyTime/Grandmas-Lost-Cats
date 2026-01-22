class_name Cat
extends Node2D
@export var cat_name: String = ""
@export var description: String = ""
@export var texture: Texture2D = null
@export var id: int = 0
@export var required_items: Array[Enums.ItemType] = []
@onready var cat_sprite: Sprite2D = $CatSprite
@onready var interact_collider: CollisionShape2D = $InteractComponent/InteractCollider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.register_cat.emit(self)
	cat_sprite.texture = texture


func handle_interact(player: Player) -> void:
	if required_items.is_empty():
		SignalManager.cat_found.emit(id)
		queue_free()
	else:
		var held_item: ItemData = player.held_item
		if not held_item:
			return
		var held_item_type = held_item.item_type
		if _can_accept_item(held_item_type):
			# May need to prompt the player, we'll see
			player.set_held_item(null)
			_accept_item(held_item_type)


func _can_accept_item(item_type: Enums.ItemType) -> bool:
	if item_type in required_items:
		return true
	else:
		return false


func _accept_item(item_type: Enums.ItemType) -> void:
	required_items.erase(item_type)
	if required_items.is_empty():
		pass
