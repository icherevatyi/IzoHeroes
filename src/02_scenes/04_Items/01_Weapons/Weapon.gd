extends Area2D

var is_monitored: bool
var damage: float
var is_active: bool = false
var weapon_type: String
var has_effect: bool = false

onready var player = get_parent().get_owner()
onready var weapon_sprite: Sprite = $Sprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var player_sprite: Sprite = get_node("../../Sprite")
onready var camera: Camera2D = get_node("../../Camera2D")

signal do_damage(damage)
signal use_stamina(stam_value)
signal enable_attack


func _ready() -> void:
	is_monitored = monitoring
	recalculate_params()
	_connect_signal("use_stamina", player, "_on_weapon_swing_made")
	_connect_signal("enable_attack", player, "_on_attack_finished")


func activate_weapon() -> void:
	is_active = true


func recalculate_params() -> void:
	damage = get_param_value("attack_power")
	animation_player.playback_speed = float(get_param_value("attack_speed")) / 10.0


func get_param_value(param: String) -> int:
	for key in PlayerStats.stats_list.keys():
		if PlayerStats.stats_list[key].type == param:
			return PlayerStats.stats_list[key].value
	return 0


func _on_weapon_swing() -> void:
	if is_active == true:
		recalculate_params()
		if player_sprite.flip_h == false:
			weapon_sprite.flip_v = false
			animation_player.play("swing")
		if player_sprite.flip_h == true:
			weapon_sprite.flip_v = true
			animation_player.play_backwards("swing")
		emit_signal("use_stamina", 10)


func _on_attack_finished() -> void:
	emit_signal("enable_attack")


func _on_Weapon_area_entered(area) -> void:
	if is_monitored:
		if area.name == "HurtBox":
			_connect_signal("do_damage", area, "_on_damage_received")
			emit_signal("do_damage", damage)
			camera.start_shaking(0.15, 50, 3)
			disconnect("do_damage", area, "_on_damage_received")
			if has_effect == true:
				apply_effect()


func apply_effect() ->  void:
	pass


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
