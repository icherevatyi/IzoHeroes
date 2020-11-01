extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

var _response: int

onready var rage_timer: Timer = $Timers/RageTimer
onready var rage_enable_timer: Timer = $Timers/RageEnableTimer
onready var enrage_tween: Tween = $EnrageColorTween
onready var hp_enable_tween: Tween = $HPEnableTween
onready var health_top: TextureProgress = $HealthBars/BossHealth/HealthTop
onready var health_bottom: TextureProgress = $HealthBars/BossHealth/HealthBottom

func _ready():
	set_physics_process(false)
	is_main_boss = true
	health_max = 450
	health_current = health_max
	damage = 65
	drops_key = true

	health_bars.is_main_boss = true
	emit_signal("initiate_healthpool", health_max)


func _physics_process(_delta):
	if is_attacking == true:
		movement_scripts.speed = 0
	else: 
		if is_chasing == true: 
			match is_enraged:
				true:
					movement_scripts.speed = 40
				false:
					movement_scripts.speed = 30
		
	


func _enrage() -> void:
	is_enraged = true
	going_rage = false
	rage_timer.start()
	movement_scripts.initial_speed = 40
	_response = enrage_tween.interpolate_property($Sprite, "self_modulate", Color(1, 1, 1, 1), Color(0.8, 0.2, 0.2, 1), 0.35, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	_response = enrage_tween.start()


func _on_RageTimer_timeout() -> void:
	is_enraged = false
	rage_enable_timer.start()
	movement_scripts.initial_speed = 30
	_response = enrage_tween.interpolate_property($Sprite, "self_modulate", Color(0.8, 0.2, 0.2, 1), Color(1, 1, 1, 1), 0.35, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	_response = enrage_tween.start()


func _on_RageEnableTimer_timeout() -> void:
	going_rage = true


func _on_room_entered() -> void:
	set_physics_process(true)
	rage_enable_timer.start()
	_response = hp_enable_tween.interpolate_property(health_top, "self_modulate", Color(1, 1, 1, 0),  Color(1, 1, 1, 1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_enable_tween.start()
	_response = hp_enable_tween.interpolate_property(health_bottom, "self_modulate", Color(1, 1, 1, 0),  Color(1, 1, 1, 1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_enable_tween.start()
