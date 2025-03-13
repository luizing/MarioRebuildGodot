extends CharacterBody2D
class_name Player
enum PlayerMode{small,big,shooting}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var animated_sprite_2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var area_colision_shape_2d = $Area2D/AreaColisao
@onready var body_colision_shape_2d = $CollisionShape2D

@export_group ('Locomoçao')
@export var run_speed_damping = 0.5
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -350.0

var player_mode = PlayerMode.small

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("pular") and velocity.y < 0:
		velocity.y *= 0.5
		
	var direction := Input.get_axis("esquerda", "direita")
	if direction:
		velocity.x = lerp(velocity.x, SPEED * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		
	animated_sprite_2d.trigger_animation(velocity, direction, player_mode)

	move_and_slide()
