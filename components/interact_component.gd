class_name InteractComponent  
extends Area2D
@export var interactable_node: Node2D = null

 
func _ready() -> void:
	if not interactable_node.has_method("handle_interact"):
		push_error("Interactable Node does not have method 'handle_interact'")


func handle_interact() -> void:
	interactable_node.handle_interact()


func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	add_to_group(Constants.INTERACTABLES_GROUP_NAME)


func _on_body_exited(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	remove_from_group(Constants.INTERACTABLES_GROUP_NAME)
