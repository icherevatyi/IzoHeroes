extends Node2D

# Health Section
var health_current: int = 4
var health_max: int = 8
var health_min: int = 0

onready var player: KinematicBody2D = get_node("../../")

func _on_damage_taken(damage) -> void:
	player.health_is_damaged = true
	health_current -= damage
	if health_current <= 0:
		player_died()
	health_current = int(max(0, health_current))


func player_died() -> void:
	player.health_is_damaged = false
	player.is_dead = true
