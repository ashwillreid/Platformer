extends StateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	add_state('idle')
	add_state('jumping')
	add_state('charging')
	add_state('shooting')
	add_state('walking')
	print('states?', states)
	set_state('idle')
	
func _state_logic(delta):
	print('in thurrr')
	if not parent.is_on_floor():
			parent.velocity.y += gravity * delta

	match state:
		states.idle:
			parent.animated_sprite_2d.play("idle")
	
	#parent.move_and_slide()
func _get_transition(_delta):
	return null

func _enter_state(_new_state, _old_state):
	pass

func _exit_state(_old_state, _new_state):
	pass
