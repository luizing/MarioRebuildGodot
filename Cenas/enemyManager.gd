extends Node
signal fim
var enemy_count = 0

func _ready():
	# Conta todos os inimigos ao iniciar
	enemy_count = get_tree().get_nodes_in_group("Enemies").size()
	print(enemy_count)


func _on_goomba_enemy_died() -> void:
	print(enemy_count)
	enemy_count -= 1
	if enemy_count == 0:
		emit_signal("fim")
		print("inimigos derrotados")
