class_name Player
extends CharacterBody2D

@export var MAX_SPEED: float = 85.0
const FRICTION: float =  300.0
const ACCELERATION: float = 300.0
const TURN_DAMP: float = 0.7
var input_direction_x_axis: float = 0
var held_item: ItemData = null
@onready var player_collider: CollisionShape2D = $PlayerCollider
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var held_item_sprite: Sprite2D = $HeldItemSprite
@onready var player_camera: Camera2D = $PlayerCamera


func _ready() -> void:
	SignalManager.pickup_item.connect(func(item_data: ItemData) -> void:
		# We swap items if we are already holding one
		# This makes it so that players don't always need to drop the current one
		if held_item != null:
			_drop_item()
		held_item = item_data
		held_item_sprite.texture = held_item.item_texture
	)
	player_camera.offset.x = player_camera.LOOKAHEAD_OFFSET


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var prev_input_direction_x_axis: float= input_direction_x_axis
	input_direction_x_axis = Input.get_axis("move_left", "move_right")
	
	if prev_input_direction_x_axis != 0 and input_direction_x_axis != 0:
		if input_direction_x_axis < 0:
			held_item_sprite.position.x = -abs(held_item_sprite.position.x)
			player_camera.swap_lookahead(Vector2.LEFT.x)
		else:
			held_item_sprite.position.x = abs(held_item_sprite.position.x)
			player_camera.swap_lookahead(Vector2.RIGHT.x)
	
	if prev_input_direction_x_axis != input_direction_x_axis:
		velocity.x *= TURN_DAMP
	
	
	if input_direction_x_axis != 0:
		velocity.x = move_toward(velocity.x, MAX_SPEED * input_direction_x_axis, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_item") and held_item:
		_drop_item()
	elif Input.is_action_just_pressed("interact"):
		var interact_node = get_tree().get_first_node_in_group(Constants.INTERACTABLES_GROUP_NAME)
		if interact_node:
			interact_node.handle_interact()

func _drop_item() -> void:
	SignalManager.dropped_item.emit(held_item, held_item_sprite.global_position)
	held_item = null
	held_item_sprite.texture = null
