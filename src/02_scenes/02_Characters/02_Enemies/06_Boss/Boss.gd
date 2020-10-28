extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

onready var rage_timer: Timer = $Timers/RageTimer


func _ready():
	is_main_boss = true
	health_max = 450
	health_current = health_max
	damage = 65
	drops_key = true
	$Sprite.self_modulate = Color(0.8, 0.2, 0.2, 1)

	health_bars.is_main_boss = true
	emit_signal("initiate_healthpool", health_max)


func _enrage() -> void:
	rage_timer.start()
	movement_scripts.initial_speed = 40
	$Sprite.self_modulate = Color(0.8, 0.2, 0.2, 1)
