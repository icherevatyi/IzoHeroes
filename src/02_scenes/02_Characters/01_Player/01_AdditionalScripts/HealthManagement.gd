extends Node2D

# Health Section
var health_current: int
var health_max: int
var health_min: int

onready var player: KinematicBody2D = get_node("../../")


func _ready() -> void:
	health_current = ResourceStorage.player_data.health_current
	health_max = PlayerStats.stats_list[0].value
	health_min = 0


func _on_damage_taken(damage) -> void:
	player.health_is_damaged = true
	health_current -= damage
	if health_current <= 0:
		player_died()
	health_current = int(max(0, health_current))


func _on_damage_healed(damage) -> void:
	health_current += damage
	health_current = int(min(health_current, health_max))


func player_died() -> void:
	player.health_is_damaged = false
	player.is_dead = true
	Global.is_player_dead = true
	Global.call_deathscreen_menu()
