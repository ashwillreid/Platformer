class_name Player extends CharacterBody2D

const BULLET = preload("res://scenes/player/bullet.tscn")

@onready var timer = $Timer
@onready var collision_shape_2d = $CollisionShape2D
@onready var floor_detector = $FloorDetector
@onready var game_manager = get_node("/root/Game/GameManager")
@onready var health = game_manager.health
@onready var camera_2d = $Camera2D
@onready var pause_menu = $MarginContainer/PauseMenu
@onready var game_over = $MarginContainer/GameOver
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle = $AnimatedSprite2D/muzzle

const JUMP_VELOCITY = -300.0
var speed = 130.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canJump = true
var isShooting = false
var isDead = false
var inIframe = false
var damageFrames = 10
var heldFrameCounter: float = 0.0
var isHeldEnough: bool = false
var canCharge : bool = true

signal damageTaken
signal pause
signal playerDied
signal playerDidShoot
func handleDamage(amount: int, incomingPosition: Vector2):
	damageTaken.emit()
	health -= amount
	if health <= 0:
		handleDeath()
	var diff = incomingPosition.x - position.x
	inIframe = true
	if ( diff >= 305 && diff < 315 ):
		velocity.y = JUMP_VELOCITY * .8
		velocity.x = JUMP_VELOCITY * -.5
	else:
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
	if isShooting:
		var shootDirection : int
		if animated_sprite_2d.flip_h:
			shootDirection = -1
		else:
			shootDirection = 1
		if isHeldEnough == false:
			heldFrameCounter = 0
			if is_on_floor():
				animated_sprite_2d.play("shoot")
		if isHeldEnough == true:
			isHeldEnough = false
			heldFrameCounter = 0.0
			animated_sprite_2d.play("shoot")
		isShooting = false
		playerDidShoot.emit(BULLET, muzzle.global_position, shootDirection)

func handleAttack(delta):
	if Input.is_action_pressed("attack"):
		isShooting = true
		animated_sprite_2d.play("charge")
		heldFrameCounter += delta
	if heldFrameCounter > 1:
		isHeldEnough = true

func handleInputs(delta):
	var direction = Input.get_axis("Left", "Right")
	# Handle jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if !is_on_floor() && canJump:
			canJump = false
			velocity.y = JUMP_VELOCITY * .8 
			
	handleAttack(delta)
	return direction

func changeDirection(direction):
	if direction < 0:
			animated_sprite_2d.flip_h = true	
	elif direction > 0:
			animated_sprite_2d.flip_h = false
	
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
		var direction = handleInputs(delta)
			
		changeDirection(direction)
		
		# Handle Animations
		if is_on_floor():
			if !isShooting:
				if direction:
					if direction != direction:
						print('changed directions')
					animated_sprite_2d.play("move")
				else:
					animated_sprite_2d.play("idle")
		else:
			if !isShooting:
				animated_sprite_2d.play("jump")
		# Apply velocity
		if isShooting:
			velocity.x = direction * speed / 2
		else:
			velocity.x = direction * speed
		
		if Input.is_action_just_pressed("Pause"):
			pause.emit()
			get_tree().paused = true
	else:
		damageFrames -= 1
		if damageFrames <= 0:
			inIframe = false
			damageFrames = 10
	
	
	move_and_slide()
