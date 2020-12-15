extends "res://src/02_scenes/04_Items/01_Weapons/Weapon.gd"

func _ready() -> void:
	weapon_type = "blood_falchion"
	is_active = false
	has_effect = true


func apply_effect() -> void:
	player.emit_signal("damage_heal", damage * 0.1)
	.apply_effect()
