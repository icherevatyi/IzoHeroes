extends KinematicBody2D

var type: String
var health_current: int
var health_max: int
var damage: int

onready var health_bars: Node2D = $HealthBars

signal initiate_healthpool(health_maximum)
signal manage_healthbar_change(hp_before_damage, hp_after_damage)


func _ready() -> void:
	_connect_signal("manage_healthbar_change", health_bars, "_on_healthbar_updated")
	_connect_signal("initiate_healthpool", health_bars, "_on_healthbar_initiated")
	


func _get_stats(enemy_type: String) -> void:
	var enemies = Lists.enemy_list
	
	for enemy in enemies:
		if enemies[enemy].type == enemy_type:
			health_max = enemies[enemy].health_max
			health_current = health_max
			damage = enemies[enemy].damage


func receive_damage(damage) -> void:
	var health_prev = health_current
	health_current -= damage
	health_current = max(0, health_current)
	
	emit_signal("manage_healthbar_change", health_prev, health_current)
	yield(get_tree().create_timer(0.35), "timeout")
	
	if health_current == 0:
		_death()
		


func _death() -> void:
	print("Skeleton dies")
	call_deferred("queue_free")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
