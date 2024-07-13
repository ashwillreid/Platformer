extends StateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	add_state('idle')
	add_state('jumping')
	add_state('charging')
	add_state('shooting')
	add_state('walking')
	print('states?', states)
	
func _state_logic(delta):
	#if not parent.is_on_floor():
			#parent.velocity.y += gravity * delta

	match state:
		states.idle:
			parent.animated_sprite_2d.play("idle")
	
	parent.move_and_slide()
func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
