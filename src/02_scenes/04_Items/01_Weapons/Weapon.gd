extends Area2D

var is_monitored: bool
var damage: int
var can_swing: bool = true

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var player_sprite: Sprite = get_node("../../Sprite")
onready var swing_timer: Timer = $SwingTimer

signal do_damage(damage)


func _ready() -> void:
	damage = get_param_value("attack_power")
	is_monitored = monitoring
	animation_player.playback_speed = 2
	swing_timer.set_wait_time(float(get_param_value("attack_speed")) / 10)

func get_param_value(param: String) -> int:
	for key in PlayerStats.stats_list.keys():
		if PlayerStats.stats_list[key].type == param:
			return PlayerStats.stats_list[key].value
	return 0


func _on_weapon_swing() -> void:
	if can_swing == false: 
		return
	if player_sprite.flip_h == false:
		animation_player.play("swing")
	if player_sprite.flip_h == true:
		animation_player.play_backwards("swing")
	can_swing = false
	swing_timer.start()


func _on_Weapon_area_entered(area) -> void:
	if is_monitored:
		if area.name == "HurtBox":
			_connect_signal("do_damage", area, "_on_damage_received")
			emit_signal("do_damage", damage)
			get_node("../../Camera2D").start_shaking(0.1, 18, 3)
			disconnect("do_damage", area, "_on_damage_received")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)


func _on_AttackTimer_timeout() -> void:
	can_swing = true
