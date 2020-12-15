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


func _ready() -> void:
	damage = get_param_value("attack_power")
	is_monitored = monitoring
	animation_player.playback_speed = float(get_param_value("attack_speed")) / 10


func get_param_value(param: String) -> int:
	for key in PlayerStats.stats_list.keys():
		if PlayerStats.stats_list[key].type == param:
			return PlayerStats.stats_list[key].value
	return 0


func _on_weapon_swing() -> void:
	if is_active == true:
		if player_sprite.flip_h == false:
			weapon_sprite.flip_v = false
			animation_player.play("swing")
		if player_sprite.flip_h == true:
			weapon_sprite.flip_v = true
			animation_player.play_backwards("swing")


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
