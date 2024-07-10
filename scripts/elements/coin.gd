extends Area2D

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer

signal pickup_coin()

func _on_body_entered(_body):
	pickup_coin.emit()
	animation_player.play("pickup")
