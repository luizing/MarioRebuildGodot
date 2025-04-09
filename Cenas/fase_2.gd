extends Node

var cronometro = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func _on_timer_timeout() -> void:
	cronometro -= 1
	$CharacterBody2D/Camera2D/Label.text = "Timer: " + str(cronometro)
	if cronometro == 0:
		#GameOver
		$CharacterBody2D/Camera2D/Label.text = "TimeOut"
		get_tree().reload_current_scene()
