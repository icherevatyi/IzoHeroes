extends Node2D

# Health Section
var health_current: int
var health_max: int
var health_min: int
var in_danger: bool
var _responce: int

onready var player: KinematicBody2D = get_node("../../")
signal grayscale_on
signal _lvl_start_grayscale_on
signal grayscale_off

func _ready() -> void:
	_responce = connect("grayscale_on", player, "_on_grayscale_enabled")
	_responce = connect("_lvl_start_grayscale_on", player, "_load_injured")
	_responce = connect("grayscale_off", player, "_on_grayscale_disabled")
	
	health_current = ResourceStorage.player_data.health_current
	health_max = PlayerStats.stats_list[0].value
	health_min = 0
	
	if health_current <= 2:
		emit_signal("_lvl_start_grayscale_on")


func _on_damage_taken(damage) -> void:
	player.health_is_damaged = true
	health_current -= damage
	if health_current <= 0:
		player_died()
	health_current = int(max(0, health_current))
	_check_health_status()


func _on_damage_healed(damage) -> void:
	health_current += damage
	health_current = int(min(health_current, health_max))
	_check_health_status()


func _check_health_status() -> void:
	if health_current <= 0:
		emit_signal("grayscale_off")
	if health_current > 0 and health_current <= 2:
		if in_danger == false:
			emit_signal("grayscale_on")
		in_danger = true
	if health_current > 2:
		if in_danger == true:
			emit_signal("grayscale_off")
		in_danger = false


func player_died() -> void:
	player.health_is_damaged = false
	player.is_dead = true
	Global.is_player_dead = true


func _call_death_menu() -> void:
	Global.call_deathscreen_menu()
