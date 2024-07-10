extends Area2D

@onready var game_manager = get_node("/root/Game/GameManager")
@onready var current_level = game_manager.current_level

func _on_body_entered(body):
	game_manager.end_level()
	game_manager.set_level(current_level + 1)
	game_manager.load_level()
