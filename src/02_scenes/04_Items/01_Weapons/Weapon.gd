extends Area2D

var is_monitored: bool
var damage: int = 35

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var player_sprite: KinematicBody2D = get_node("../../Sprite")

signal do_damage(damage)


func _ready() -> void:
	is_monitored = monitoring
	animation_player.playback_speed = 3


func _on_weapon_swing() -> void:
	var current_position = int(rotation_degrees)
	if player_sprite.flip_h == false:
		animation_player.play("swing")
	if player_sprite.flip_h == true:
		animation_player.play_backwards("swing")


func _on_Weapon_area_entered(area) -> void:
	if is_monitored:
		if area.name == "HurtBox":
			_connect_signal("do_damage", area, "_on_damage_received")
			emit_signal("do_damage", damage)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
