extends Node2D
@export var starting_room_type: Enums.RoomType = Enums.RoomType.TEST1
@onready var test_room: Room = $TestRoom
@onready var test_room_2: Room = $TestRoom2

var room_lookup_table: Dictionary[Enums.RoomType, Room] = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.swap_room.connect(_handle_room_swap)
	_set_up_table()
	_handle_room_swap(starting_room_type, 0, [null, -1])


func _set_up_table() -> void:
	room_lookup_table = {
		Enums.RoomType.TEST1: test_room,
		Enums.RoomType.TEST2: test_room_2
	}


func _handle_room_swap(to_room_type: Enums.RoomType, transition_area_id: int, player_data: Array) -> void:
	var to_room: Room = room_lookup_table[to_room_type]
	to_room.handle_player_entered()
	to_room.spawn_player(player_data, transition_area_id)
