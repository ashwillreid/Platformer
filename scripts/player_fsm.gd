extends StateMachine
@onready var player = $".."

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	add_state('idle')
	add_state('jumping')
	add_state('charging')
	add_state('shooting')
	add_state('walking')
	
	print('states?', states.idle)
	
	set_state('idle')
	
func _state_logic(delta):
	pass
	#print('in thurrr')
	#if player is Player:
		#if not player.is_on_floor():
			#player.velocity.y += gravity * delta

		#match states[state]:
			#states.idle:
				#player.animated_sprite_2d.play("idle")
		
		#player.move_and_slide()
func _get_transition(_delta):
	return null

func _enter_state(_new_state, _old_state):
	pass

func _exit_state(_old_state, _new_state):
	pass
