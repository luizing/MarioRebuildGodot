extends Area2D

@onready var collision_shape = $CollisionShape2D

func _ready():
	# Força todas as configurações manualmente
	collision_layer = 8
	collision_mask = 1
	z_index = 0
	set_meta("is_door", true)  # Identificação adicional
	
	# Conexão de sinal 100% garantida
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func activate():
	collision_shape.disabled = false
	print("DEBUG PORTA - Estado atual:",
		  "\nPosição:", global_position,
		  "\nColisão ativa?", !collision_shape.disabled,
		  "\nShape size:", collision_shape.shape.get_rect().size)

func _on_body_entered(body):
	var debug_msg = [
		"CORPO ENTERADO NA PORTA:",
		"Nome: " + str(body.name),
		"É Player? " + str(body.is_in_group("player")),
		"Posição: " + str(body.global_position),
		"Distância: " + str(global_position.distance_to(body.global_position))
	]
	print("\n".join(debug_msg))
	
	if body.is_in_group("player") && !collision_shape.disabled:
		print("CONDIÇÕES SATISFEITAS - INICIANDO TRANSIÇÃO")
		get_tree().change_scene_to_file("res://Cenas/inicio.tscn")


func _on_area_entered(area: Area2D, body) -> void:
	var debug_msg = [
		"CORPO ENTERADO NA PORTA:",
		"Nome: " + str(body.name),
		"É Player? " + str(body.is_in_group("player")),
		"Posição: " + str(body.global_position),
		"Distância: " + str(global_position.distance_to(body.global_position))
	]
	print("\n".join(debug_msg))
	
	if body.is_in_group("player") && !collision_shape.disabled:
		print("CONDIÇÕES SATISFEITAS - INICIANDO TRANSIÇÃO")
		get_tree().change_scene_to_file("res://Cenas/inicio.tscn")
