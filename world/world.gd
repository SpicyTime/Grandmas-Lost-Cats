extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.dropped_item.connect(_spawn_item_pickup)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _spawn_item_pickup(item_data: ItemData, spawn_position: Vector2) -> void:
	var pickup_instance: ItemPickup = load(Constants.ITEM_PICKUP_PATH).instantiate()
	pickup_instance.position = spawn_position
	pickup_instance.item_data = item_data
	add_child(pickup_instance)
