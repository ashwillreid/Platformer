extends Area2D
@onready var killzone = $"."

@onready var timer = $Timer

func _on_body_entered(body):
	print('body???', body)
	if body is Player:
		body.handleDamage(1, global_position)
