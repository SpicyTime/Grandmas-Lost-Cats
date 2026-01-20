class_name Room
extends Node2D
@export var room_length: float = 320
@export var camera_limit_offsets: Vector2 = Vector2.ZERO
const PLAYER_SCENE_PATH: String = "res://world/player/player.tscn"
@onready var item_container: Node2D = $Items

func handle_player_exited() -> void:
	visible = false


func handle_player_entered() -> void:
	visible = true


func spawn_player(player_data: Array, from_transition_area_id: int) -> void:
	var player_scene: Player = load(PLAYER_SCENE_PATH).instantiate()
	
	call_deferred("add_child", player_scene)
	await player_scene.ready
	player_scene.player_camera.limit_left = position.x + int(-room_length / 2)
	player_scene.player_camera.limit_right = position.x + int(room_length / 2)
	player_scene.set_up_player(player_data)
	for spawn_marker in $SpawnMarkers.get_children():
		if spawn_marker.connecting_id == from_transition_area_id:
			player_scene.position = spawn_marker.position
	
