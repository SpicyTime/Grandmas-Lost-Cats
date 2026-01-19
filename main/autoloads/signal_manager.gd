extends Node

signal pickup_item(item_data: ItemData)
signal dropped_item(item_data: ItemData, position: Vector2)

signal cat_found(id: int)
signal register_cat(cat: Cat)
