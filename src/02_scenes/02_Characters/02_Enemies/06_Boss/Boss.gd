extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

var amulet: PackedScene = preload("res://src/02_scenes/04_Items/02_Loot/04_Amulet/Amulet.tscn")

var _response: int
var is_hp_shown: bool = false

onready var rage_timer: Timer = $Timers/RageTimer
onready var rage_enable_timer: Timer = $Timers/RageEnableTimer
onready var enrage_tween: Tween = $EnrageColorTween
onready var hp_enable_tween: Tween = $HPEnableTween
onready var hp_container: Control = $HealthBars/BossHealth/BossHPContainer
onready var health_top: TextureProgress = $HealthBars/BossHealth/BossHPContainer/HealthTop
onready var health_bottom: TextureProgress = $HealthBars/BossHealth/BossHPContainer/HealthBottom



func _ready():
	type = "boss"
	is_main_boss = true
	health_max = 450
	health_current = health_max
	damage = 15
	drops_key = false

	health_bars.is_main_boss = true
	emit_signal("initiate_healthpool", health_max)
	hp_container.modulate = Color(1, 1, 1, 0)


func _enrage() -> void:
	is_enraged = true
	going_rage = false
	rage_timer.start()
	_response = enrage_tween.interpolate_property($Sprite, "self_modulate", Color(1, 1, 1, 1), Color(0.8, 0.2, 0.2, 1), 0.35, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	_response = enrage_tween.start()


func _play_enraged_sound() -> void:
	var sound = Lists.boss_enrage_sound
	e_voice_sfx.set_stream(sound)
	e_voice_sfx._set_playing(true)


func _on_RageTimer_timeout() -> void:
	is_enraged = false
	rage_enable_timer.start()
	_response = enrage_tween.interpolate_property($Sprite, "self_modulate", Color(0.8, 0.2, 0.2, 1), Color(1, 1, 1, 1), 0.35, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	_response = enrage_tween.start()


func _on_RageEnableTimer_timeout() -> void:
	going_rage = true


func _on_DetectionRange_body_entered(body) -> void:
	if body.name == "Player":
		get_owner().bossfight_music_start()
		player_position_update_timer.start()
		rage_enable_timer.start()
		is_chasing = true
		if is_hp_shown == false and is_dead == false:
			_response = hp_enable_tween.interpolate_property(hp_container, "modulate", Color(1, 1, 1, 0),  Color(1, 1, 1, 1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			_response = hp_enable_tween.start()


func _hide_healthbar() -> void:
	_response = hp_enable_tween.interpolate_property(hp_container, "modulate", Color(1, 1, 1, 1),  Color(1, 1, 1, 0), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_enable_tween.start()
	_on_mainboss_death()


func _drop_amulet() -> void:
	var amulet_instance = amulet.instance()
	amulet_instance.set_global_position(get_global_position())
	get_owner().get_node("Loot").add_child(amulet_instance)


func _on_mainboss_death() -> void:
	get_owner()._on_boss_died()
