extends Node2D
const TOTAL_CAT_COUNT: int = 3
var cats_found: int = 0
var found_cats: Dictionary[int, bool] = {}
var registered_cats: Dictionary[int, Cat] = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.cat_found.connect(_on_cat_found)
	SignalManager.register_cat.connect(_register_cat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_cat_found(id: int) -> void:
	cats_found += 1
	found_cats[id] = true
	if cats_found == TOTAL_CAT_COUNT:
		print("Every Cat Found")


func _register_cat(cat_instance: Cat) -> void:
	registered_cats[cat_instance.id] = cat_instance
	found_cats[cat_instance.id] = false
