extends Node2D

# Health Section
var health_current: int
var health_max: int
var health_min: int
var stam_current: int
var stam_max: int
var stam_min: int
var in_danger: bool
var _responce: int

onready var player: KinematicBody2D = get_node("../../")
onready var HUD: CanvasLayer = get_node("../../HUD")
onready var stam_regen_timer: Timer = get_node("../../Timers/StaminaRegenTimer")
onready var stam_delay_timer: Timer = get_node("../../Timers/StaminaDelayTimer")

signal _stam_depleeted
signal _stam_restored
signal _stam_regenerated(value)


func _ready() -> void:
	Global.is_player_dead = false
	_connect_signal("_stam_depleeted", player, "_on_stam_depleeted")
	_connect_signal("_stam_restored", player, "_on_stam_restored")
	_connect_signal("_stam_regenerated", HUD, "_on_stam_regenerated")
	
	health_current = ResourceStorage.player_data.health_current
	health_max = PlayerStats.stats_list[0].value
	health_min = 0
	
	stam_current = PlayerStats.stats_list[1].value
	stam_max = PlayerStats.stats_list[1].value
	stam_min = 0


func _on_stamina_used(value) -> void:
	stam_regen_timer.stop()
	stam_delay_timer.stop()
	stam_delay_timer.set_wait_time(1)
	stam_current = int(stam_current - value)
	stam_current = int(max(stam_current, 0))
	stam_delay_timer.start()
	if stam_current <= 0:
		emit_signal("_stam_depleeted")
		stam_delay_timer.set_wait_time(2)
		stam_delay_timer.start()


func _on_StaminaDelayTimer_timeout():
	stam_regen_timer.start()


func _on_StaminaRegenTimer_timeout() -> void:
	stam_current = int(min(stam_current, stam_max))
	if stam_current >= 20:
		emit_signal("_stam_restored")
	if stam_current >= stam_max:
		stam_regen_timer.stop()
		return
	var regen_value = 2
	stam_current = stam_current + regen_value
	emit_signal("_stam_regenerated", regen_value)
	stam_regen_timer.start()


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


func _call_death_menu() -> void:
	Global.toggle_pause_menu()


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
