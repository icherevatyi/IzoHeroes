extends Node2D

enum STATE_VALUES {
	IDLE,
	WALK,
	CHASE,
	ATTACK,
	RECEIVE_DAMAGE,
	DEATH
}


var state_machine
onready var enemy: KinematicBody2D = get_node("../../")


func _ready() -> void:
	state_machine = get_node("../../AnimationTree").get("parameters/playback")

func _set_state(state) -> void:
	match state:
		STATE_VALUES.IDLE:
			state_machine.travel("idle")
		STATE_VALUES.WALK:
			state_machine.travel("walk")
		STATE_VALUES.CHASE:
			state_machine.travel("chase")
		STATE_VALUES.ATTACK:
			state_machine.travel("attack")
		STATE_VALUES.RECEIVE_DAMAGE:
			state_machine.travel("receive_damage")
		STATE_VALUES.DEATH:
			state_machine.travel("death")


func monitor_states() -> void:
	if enemy.is_dead == false:
		if enemy.movement == Vector2.ZERO:
			_set_state(STATE_VALUES.IDLE)
		if enemy.movement != Vector2.ZERO and enemy.is_chasing == false:
			_set_state(STATE_VALUES.WALK)
		if enemy.movement != Vector2.ZERO and enemy.is_chasing == true:
			_set_state(STATE_VALUES.CHASE)
		if enemy.is_in_attack_range == true:
			_set_state(STATE_VALUES.ATTACK)
		if enemy.is_taking_damage == true:
			_set_state(STATE_VALUES.RECEIVE_DAMAGE)
	else:
		_set_state(STATE_VALUES.DEATH)
