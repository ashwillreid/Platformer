extends Node
class_name StateMachine

@onready var parent = get_parent()

var state = null
var previous_state = null
var states = {}

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transistion = _get_transition(delta)
		if transistion != null:
			set_state(transistion)

func _state_logic(delta):
	pass

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass


func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	
	if new_state != null:
		_enter_state(new_state, previous_state)

func add_state(state_name):
	states[state_name] = states.size()
	
