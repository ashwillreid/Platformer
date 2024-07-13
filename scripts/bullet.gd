extends Node2D
@onready var ray_cast_2d = $RayCast2D

var speed = 400

var direction := Vector2.ZERO

func setDirection(direction: Vector2):
	self.direction = direction

func handleHit(collisionObj):
	queue_free()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
