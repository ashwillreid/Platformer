extends Node2D

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right_lower = $RayCastRightLower
@onready var ray_cast_left_lower = $RayCastLeftLower
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_top = $RayCastTop
@onready var killzone = $Killzone
@onready var bullet_detector = $BulletDetector


const SPEED = 40
var direction = 1
var isDead = false


func wasShotCallback():
	isDead = true
	killzone.queue_free()
	bullet_detector.queue_free()
	animated_sprite_2d.play("death")
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if isDead:
		pass
	else:
		if ray_cast_right.is_colliding():
			direction = -1
		if ray_cast_left.is_colliding():
			direction = 1
		if !ray_cast_right_lower.is_colliding():
			direction = -1
		if !ray_cast_left_lower.is_colliding():
			direction = 1
		position.x += direction * SPEED * delta
