extends Node2D

onready var parent: KinematicBody2D = get_node("../../")
onready var hitbox: Area2D = parent.get_node("HitBox")


signal attack(dmg)


func _aim_at_player(player_pos) -> void:
	hitbox.look_at(player_pos)


func _on_HitBox_area_entered(area) -> void:
	if parent.is_dead == false:
		if area.name == "HurtBox":
			_connect_signal("attack", area.get_parent(), "_damage_taken")
			emit_signal("attack", parent.damage)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)


