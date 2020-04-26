extends Node2D

onready var healthbar_under: TextureProgress = $HealthUnder
onready var healthbar_upper: TextureProgress = $HealthUpper
onready var tween: Tween = get_node('../Tween')

# this variable is used to store return value of a function
var _function_val_storage

func _on_healthbar_initiated(healthpool) -> void:
	healthbar_under.max_value = healthpool
	healthbar_upper.max_value = healthpool
	healthbar_under.value = healthpool
	healthbar_upper.value = healthpool


func _on_healthbar_updated(hp_before_damage, hp_after_damage) -> void:
	healthbar_upper.value = hp_after_damage
	_function_val_storage = tween.interpolate_property(healthbar_under, 'value', hp_before_damage, hp_after_damage, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_function_val_storage = tween.start()
