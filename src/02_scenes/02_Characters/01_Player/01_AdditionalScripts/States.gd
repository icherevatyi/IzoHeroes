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
var prev_state: int

onready var player: KinematicBody2D = get_node("../../")


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


func monitor_states() -> void:
	if player.is_dead == false:
		if player.movement == Vector2.ZERO and player.is_bored == false:
			set_state(STATE_VALUES.IDLE_1)
		if player.movement == Vector2.ZERO and player.is_bored == true:
			set_state(STATE_VALUES.IDLE_2)
		if player.movement != Vector2.ZERO:
			set_state(STATE_VALUES.WALK)
		if player.health_is_damaged == true:
			set_state(STATE_VALUES.RECEIVE_DAMAGE)
	if player.is_dead == true:
		set_state(STATE_VALUES.DEATH)


func _on_state_changed(state) -> void:
	set_state(state)
