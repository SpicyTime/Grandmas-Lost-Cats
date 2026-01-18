extends Node2D
@export var item_strategy: ItemStrategy = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func handle_interact() -> void:
	# TO DO: 
	# 1. Play sound
	# 2. Play effects
	SignalManager.pickup_item.emit(item_strategy)
	queue_free()
