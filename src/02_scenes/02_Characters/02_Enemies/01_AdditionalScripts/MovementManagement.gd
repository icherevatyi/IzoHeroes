extends Node2D

var rng = RandomNumberGenerator.new()
var movement_dir_dict: Dictionary = {
	0: Vector2.ZERO,
	1: Vector2.UP,
	2: Vector2.DOWN,
	3: Vector2.LEFT,
	4: Vector2.RIGHT,
}

export var speed: int = 120
var movement_dir: Vector2
var velocity: Vector2

onready var parent: KinematicBody2D = get_node("../../")
onready var timer: Timer = get_node("../../Timers/MovementChangeTimer")

func _ready():
	_select_direction()
	_select_timer_timeout()


func move_enemy() -> void:
	velocity = speed * movement_dir
	if parent.is_on_wall():
		_select_direction()
		_select_timer_timeout()


func _select_timer_timeout() -> void:
	rng.randomize()
	var rand_time = rng.randi_range(1, 4)
	timer.set_wait_time(rand_time)
	timer.start()


func _select_direction() -> void:
	rng.randomize()
	var rand_dir = rng.randi_range(0, 4)
	movement_dir = movement_dir_dict[rand_dir]


func _on_MovementChangeTimer_timeout() -> void:
	_select_timer_timeout()
	_select_direction()
