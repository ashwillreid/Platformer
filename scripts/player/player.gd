extends CharacterBody2D

@onready var timer = $Timer
@onready var collision_shape_2d = $CollisionShape2D

@onready var floor_detector = $FloorDetector
@onready var game_manager = get_node("/root/Game/GameManager")
@onready var health = game_manager.health
@onready var camera_2d = $Camera2D
@onready var pause_menu = $MarginContainer/PauseMenu
@onready var game_over = $MarginContainer/GameOver
#@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D

const JUMP_VELOCITY = -300.0
var speed = 130.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canJump = true
var isShooting = false
var isDead = false
var inIframe = false
var damageFrames = 10


signal damageTaken
signal pause
signal playerDied

func killCallback():
	velocity.y = JUMP_VELOCITY * .8
	
func handleDamage(amount: int, incomingPosition: Vector2):
	damageTaken.emit()
	health -= 1
	if health <= 0:
		handleDeath()
	var diff = incomingPosition.x - position.x
	inIframe = true
	if ( diff >= 305 && diff < 315 ):
		print('right side')
		velocity.y = JUMP_VELOCITY * .8
		velocity.x = JUMP_VELOCITY * -.5
	else:
		print('left side')
		velocity.y = JUMP_VELOCITY * .8
		velocity.x = JUMP_VELOCITY * .5

func handleDeath():
	isDead = true
	velocity.y = JUMP_VELOCITY * 1
	Engine.time_scale = 0.5
	collision_shape_2d.queue_free()
	timer.start()

# RESET TIME AND RELOAD GAME AFTER DEATH TIMER
func _on_timer_timeout():
	get_tree().paused = true
	Engine.time_scale = 1
	playerDied.emit()

func _on_animated_sprite_2d_animation_finished():
	isShooting = false
	# TODO HANDLE SHOOT HEREERRE


func handleMovement():
	var direction = Input.get_axis("Left", "Right")
	# Handle jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if !is_on_floor() && canJump:
			canJump = false
			velocity.y = JUMP_VELOCITY * .8 
	
	#Handle Roll
	if Input.is_action_just_pressed("attack"):
		if is_on_floor():
			isShooting = true
	
	return direction
	
func _physics_process(delta):
	if !inIframe:
		# Add the gravity as velocity.
		if not is_on_floor():
			velocity.y += gravity * delta
		
		# Reset canJump to true when back on floor
		if is_on_floor():
			canJump = true
		
		#HANDLE MOVEMENT
		# Get the input direction and handle the movement/deceleration.
		var direction = handleMovement()
			
		# Handle sprite flipping
		if direction < 0:
			animated_sprite_2d.flip_h = true
		elif direction > 0:
			animated_sprite_2d.flip_h = false	
		
		#Handle Animations
		if is_on_floor():
			if isShooting:
				animated_sprite_2d.play("shoot")
			elif direction:
				animated_sprite_2d.play("move")
			else:
				animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("jump")
		# Apply velocity
		if isShooting:
			velocity.x = direction * speed / 2
		else:
			velocity.x = direction * speed
		
		if Input.is_action_just_pressed("Pause"):
			print('pressing pause!')
			pause.emit()
			get_tree().paused = true
	else:
		damageFrames -= 1
		if damageFrames <= 0:
			inIframe = false
			damageFrames = 10
	
	
	move_and_slide()
