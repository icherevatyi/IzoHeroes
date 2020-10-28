extends Control

var health_current: int
var health_max: int

var tween_ease := Tween.EASE_IN_OUT
var tween_trans := Tween.TRANS_LINEAR
var tween_time := 0.35

onready var health_top: TextureProgress = $HealthTop
onready var health_bottom: TextureProgress = $HealthBottom
onready var tween := $Tween

func _init_health(health: int) -> void:
	health_max = health
	health_current = health


func on_damage_taken(damage: int) -> void:
	var health_new = float(health_current - damage)
	health_new = max(health_new, 0.0)
	health_top.value =  health_new
	tween.interpolate_property(health_bottom, "value", health_current, health_new, tween_time, tween_trans, tween_ease)
	tween.start()
	health_current = health_new
