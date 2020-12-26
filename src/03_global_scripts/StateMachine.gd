extends Node
class_name StateMachine

var state = null
var prev_state = null

onready var parent = get_parent()

func _state_logic(delta):
	pass

func _get_transition(delta):
	pass
