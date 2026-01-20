extends Camera2D
const LOOKAHEAD_OFFSET: float = 8.0
const _CAMERA_SPEED: float = 4.0
var _active_lookahead_dir: float = 1.0
var is_lerping: bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_lerping:
		var final_offset: float = LOOKAHEAD_OFFSET * _active_lookahead_dir
		offset.x = lerp(offset.x, final_offset, _CAMERA_SPEED * delta)
		if offset.x == final_offset:
			is_lerping = false


func swap_lookahead(dir: float) -> void:
	_active_lookahead_dir = dir
	is_lerping = true
