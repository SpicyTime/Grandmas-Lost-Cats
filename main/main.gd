extends Node
@onready var ui_canvas_layer: CanvasLayer = $UiCanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiManager.set_up_ui(ui_canvas_layer)
