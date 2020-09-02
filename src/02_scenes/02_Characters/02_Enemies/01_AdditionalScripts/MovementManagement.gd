extends Node2D

var rng = RandomNumberGenerator.new()
var movement_dir_dict: Dictionary = {
	0: Vector2.ZERO,
	1: Vector2.UP,
	2: Vector2.DOWN,
	3: Vector2.LEFT,
	4: Vector2.RIGHT,
}

var initial_speed: int = 30
var speed: int
var movement_dir: Vector2
var velocity: Vector2

onready var parent: KinematicBody2D = get_node("../../")
onready var sprite: Sprite = get_node("../../Sprite")
onready var timer: Timer = get_node("../../Timers/MovementChangeTimer")

func _ready():
	speed = initial_speed	
	_select_direction()
	_select_timer_timeout()


func move_enemy() -> void:
	match parent.is_chasing:
		true:
			speed = initial_speed + 30
		false:
			speed = initial_speed
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
	if parent.is_dead == false:
		rng.randomize()
		var rand_dir = rng.randi_range(0, 4)
		movement_dir = movement_dir_dict[rand_dir]
		_match_facing()


func _match_facing() -> void:
	match movement_dir:
		Vector2.RIGHT:
			sprite.flip_h = false
		Vector2.LEFT:
			sprite.flip_h = true


func _on_MovementChangeTimer_timeout() -> void:
	_select_timer_timeout()
	_select_direction()


func chase_player(player_position) -> void:
	var enemy_position = parent.get_global_position()
	if (player_position.x - enemy_position.x) < 0:
		sprite.flip_h = true
	if (player_position.x - enemy_position.x) > 0:
		sprite.flip_h = false
	velocity = (player_position - enemy_position).normalized() * speed * 2


func enemy_stop(player_position) -> void:
	if parent.is_dead == false:
		var enemy_position = parent.get_global_position()
		if (player_position.x - enemy_position.x) < 0:
				sprite.flip_h = true
		if (player_position.x - enemy_position.x) > 0:
				sprite.flip_h = false
		velocity = Vector2.ZERO

