extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

var _response: int

onready var rage_timer: Timer = $Timers/RageTimer
onready var rage_enable_timer: Timer = $Timers/RageEnableTimer
onready var enrage_tween: Tween = $EnrageColorTween

func _ready():
	is_main_boss = true
	health_max = 450
	health_current = health_max
	damage = 65
	drops_key = true

	health_bars.is_main_boss = true
	emit_signal("initiate_healthpool", health_max)


func _enrage() -> void:
	is_enraged = true
	going_rage = false
	rage_timer.start()
	movement_scripts.initial_speed = 40
	_response = enrage_tween.interpolate_property($Sprite, "self_modulate", Color(1, 1, 1, 1), Color(0.8, 0.2, 0.2, 1), 0.35, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	_response = enrage_tween.start()

func _on_RageTimer_timeout():
	is_enraged = false
	rage_enable_timer.start()
	movement_scripts.initial_speed = 30
	_response = enrage_tween.interpolate_property($Sprite, "self_modulate", Color(0.8, 0.2, 0.2, 1), Color(1, 1, 1, 1), 0.35, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	_response = enrage_tween.start()


func _on_RageEnableTimer_timeout():
	going_rage = true
