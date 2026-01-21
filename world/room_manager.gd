extends Node2D
@export var starting_room_type: Enums.RoomType = Enums.RoomType.TEST1
var current_room: Room = null
var room_lookup_table: Dictionary[Enums.RoomType, Room] = {}
@onready var test_room: Room = $TestRoom
@onready var test_room_2: Room = $TestRoom2
@onready var fade_transition: CanvasLayer = $FadeTransition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.dropped_item.connect(_spawn_item_pickup)
	SignalManager.swap_room.connect(_on_swap_room_requested)
	_set_up_table()
	handle_room_swap([starting_room_type, 2, []])


func handle_room_swap(room_data: Array) -> void:
	var to_room_type = room_data[0]
	var transition_area_id = room_data[1]
	var player_data: Array = room_data[2]
	if current_room:
		current_room.handle_player_exited()
	var to_room: Room = room_lookup_table[to_room_type]
	current_room = to_room
	to_room.handle_player_entered()
	if not player_data.is_empty() :
		to_room.spawn_player(player_data, transition_area_id)
	else:
		to_room.spawn_player([], transition_area_id)


func _set_up_table() -> void:
	room_lookup_table = {
		Enums.RoomType.TEST1: test_room,
		Enums.RoomType.TEST2: test_room_2
	}


func _on_swap_room_requested(room_data: Array) -> void:
	fade_transition.transition(room_data)



func _spawn_item_pickup(item_data: ItemData, spawn_position: Vector2) -> void:
	var pickup_instance: ItemPickup = load(Constants.ITEM_PICKUP_PATH).instantiate()
	
	pickup_instance.position = current_room.to_local(spawn_position)
	pickup_instance.item_data = item_data
	
	current_room.item_container.add_child(pickup_instance)
