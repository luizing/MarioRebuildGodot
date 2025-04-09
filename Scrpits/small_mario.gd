extends CharacterBody2D
class_name Player

signal points_scored(points:int) 

enum PlayerMode{small,big,shooting}
var player_mode = PlayerMode.small
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const points_label_scene = preload("res://Cenas/points_label.tscn")
var is_dead = false

@onready var animated_sprite_2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var area_2d = $Area2D
@onready var area_colision_shape_2d = $Area2D/AreaColisao
@onready var body_colision_shape_2d = $CollisionShape2D

@export_group ('Locomoçao')
@export var run_speed_damping = 0.5
@export var SPEED = 150.0
@export var JUMP_VELOCITY = -350.0

@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150

func _physics_process(delta: float) -> void:
	
	if global_position.y > 500:  # Ajuste o valor para a altura de "queda"
			get_tree().change_scene_to_file("res://Cenas/deathzone.tscn")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("ui_p"):  # Tecla P pressionada
		get_tree().change_scene_to_file("res://Cenas/fase2.tscn")
		
	if Input.is_action_just_pressed("ui_f"):  # Tecla P pressionada
		get_tree().change_scene_to_file("res://Cenas/fim.tscn")

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


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handle_enemy_collision(area)
	else:
		die()

func handle_enemy_collision(enemy: Enemy):
	if enemy == null || is_dead: 
		return
	if is_instance_of(enemy, Koopa) and (enemy as Koopa).in_a_shell:
		(enemy as Koopa).on_stomp(global_position)
	else:
		var angle_of_collision = rad_to_deg(position.angle_to_point(enemy.position))
		
		if angle_of_collision > min_stomp_degree && max_stomp_degree > angle_of_collision:
			enemy.die()
			on_enemy_stomped()
			spawn_points_label(enemy)
		else:
			die()
		
func on_enemy_stomped():
	velocity.y = stomp_y_velocity
	
func spawn_points_label(enemy):
	var points_label = points_label_scene.instantiate()
	points_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	points_scored.emit(100)
	
func die():
	if player_mode == PlayerMode.small:
		is_dead = true
		animated_sprite_2d.play("small_death")
		set_physics_process(false)

		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -45), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 500), 1)
		death_tween.tween_callback(func (): get_tree().reload_current_scene())
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Cenas/deathzone.tscn")
