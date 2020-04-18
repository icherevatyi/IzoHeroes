extends Node2D

enum STATE_VALUES {
	IDLE_1,
	IDLE_2,
	WALK,
	ATTACK,
	RECEIVE_DAMAGE,
	DEATH
}

var state_machine


func _ready() -> void:
	state_machine = get_node("../../AnimationTree").get("parameters/playback")
	set_state(STATE_VALUES.IDLE_1)


func set_state(state) -> void:
	match state:
		STATE_VALUES.IDLE_1:
			state_machine.travel("idle_1")
		STATE_VALUES.IDLE_2:
			state_machine.travel("idle_2")
		STATE_VALUES.WALK:
			state_machine.travel("walk")
		STATE_VALUES.ATTACK:
			pass
		STATE_VALUES.RECEIVE_DAMAGE:
			state_machine.travel("receive_damage")
		STATE_VALUES.DEATH:
			state_machine.travel("death")




func _on_state_changed(state) -> void:
	set_state(state)
