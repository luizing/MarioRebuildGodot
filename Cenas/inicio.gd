extends Control


func _on_StartButton_pressed():
	print("button")
	get_tree().change_scene_to_file("res://Cenas/main.tscn")
