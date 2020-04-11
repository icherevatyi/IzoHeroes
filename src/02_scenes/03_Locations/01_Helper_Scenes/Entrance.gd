extends Node2D

var _message: String = "Iron bar closed behind you. Door is tightly sealed and the only way to leave this place is to move forward."

onready var spawn_point: Position2D = $SpawnPoint
onready var _current_lvl: Node2D = get_parent()
onready var player: PackedScene = preload("res://src/02_scenes/02_Characters/01_Player/Player.tscn")

signal _message_sent(msg)


func _ready() -> void:
	_spawn_player()


func _spawn_player() -> void:
	var p_instance: KinematicBody2D = player.instance()
	p_instance.set_global_position(spawn_point.get_global_position())
	_current_lvl.call_deferred("add_child", p_instance)

	_connect_signal("_message_sent", p_instance, "_on_message_received")


func _on_MessageTrigger_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		emit_signal("_message_sent", _message)


func _connect_signal(signal_title: String, target_node: Node2D, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
