extends Area2D
var player_in_area = false
var portaAberta = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if portaAberta and player_in_area and Input.is_action_just_pressed("Action"):
		get_tree().change_scene_to_file("res://Cenas/fim.tscn")
	
func _on_area_entered(area: Area2D) -> void:
	player_in_area = true
	print("entrou")

func _on_area_exited(area: Area2D) -> void:
	print("saiu")
	player_in_area = false
