extends KinematicBody2D

export var is_taking_damage: bool = false
var type: String
var health_current: int
var health_max: int
var damage: int
var is_dead: bool = false

onready var detection_range: Area2D = $DetectionRange
onready var attack_scripts: Node2D = $AdditionalScripts/AttackManagement
onready var movement_scripts: Node2D = $AdditionalScripts/MovementManagement
onready var state_scripts: Node2D = $AdditionalScripts/StatesManagement
onready var movement_timer: Timer = $Timers/MovementChangeTimer
onready var health_bars: Node2D = $HealthBars

var movement
var is_chasing: bool = false
var is_attacking: bool = false

signal initiate_healthpool(health_maximum)
signal manage_healthbar_change(hp_before_damage, hp_after_damage)


func _ready() -> void:
	_connect_signal("manage_healthbar_change", health_bars, "_on_healthbar_updated")
	_connect_signal("initiate_healthpool", health_bars, "_on_healthbar_initiated")
	emit_signal("initiate_healthpool", health_max)


func _physics_process(_delta):
	if is_dead == false:
		match is_chasing:
			false:
				movement_scripts.move_enemy()
			true:
				for body in detection_range.get_overlapping_bodies():
					if body.name == "Player":
						match is_attacking:
							false:
								movement_scripts.chase_player(body.get_global_position())
							true:
								movement_scripts.enemy_stop(body.get_global_position())
								attack_scripts._face_player(body.get_global_position())
		movement = move_and_slide(movement_scripts.velocity, Vector2(0, 0))
	state_scripts.monitor_states()


func _get_stats(enemy_type: String) -> void:
	var enemies = Lists.enemy_list
	
	for enemy in enemies:
		if enemies[enemy].type == enemy_type:
			health_max = enemies[enemy].health_max
			health_current = health_max
			damage = enemies[enemy].damage


func receive_damage(damage_received) -> void:
	var health_prev = health_current
	health_current -= damage_received
	health_current = int(max(0, health_current))
	
	is_taking_damage = true
	emit_signal("manage_healthbar_change", health_prev, health_current)
	yield(get_tree().create_timer(0.35), "timeout")
	
	if health_current == 0:
		_death()
		


func _death() -> void:
	is_dead = true
	$CollisionShape2D.disabled = true
	health_bars.visible = false


func _on_DetectionRange_body_entered(body):
	if body.name == "Player":
		is_chasing = true


func _on_DetectionRange_body_exited(body):
	if body.name == "Player":
		is_chasing = false



func _on_AttackRange_body_entered(body):
	if body.name == "Player":
		is_attacking = true
		print(is_attacking)


func _on_AttackRange_body_exited(body):
	if body.name == "Player":
		is_attacking = false
		print(is_attacking)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
