extends Area2D
@export var to_room_type: Enums.RoomType = Enums.RoomType.TEST1
@export var area_id: int = 0

func set_to_room_type(room_type: Enums.RoomType) -> void:
	to_room_type = room_type

 
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player_data: Array = body.get_data()
		get_parent().get_parent().call_deferred("handle_player_exited")
		SignalManager.swap_room.emit(to_room_type, area_id, player_data)
		body.call_deferred("queue_free")
