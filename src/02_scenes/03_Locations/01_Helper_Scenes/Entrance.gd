extends Node2D


var activation_indicator: PackedScene = preload("res://src/02_scenes/01_UI/06_InterractionIndicator/InterractionIndicator.tscn")

var spawn_node: YSort
var _message: String

var item_data: Dictionary = {
	"title": "Entrance Gate",
	"type": "gate"
}

var signals_dictionary = {
		0: {
			"signal_title": "send_data",
			"connected_function": "_on_data_received"
		},
		1: {
			"signal_title": "show_label",
			"connected_function": "_on_indicator_enabled"
		},
		2: {
			"signal_title": "hide_label",
			"connected_function": "_on_indicator_disabled"
			},
		3: {
			"signal_title": "start_activation",
			"connected_function": "_on_activation_started"
		},
		4: {
			"signal_title": "stop_activation",
			"connected_function": "_on_activation_stopped"
		},
	}

onready var spawn_point: Position2D = $SpawnPoint
onready var dungeon_lvl: Node2D = get_node("/root/Dungeon")
onready var player: PackedScene = preload("res://src/02_scenes/02_Characters/01_Player/Player.tscn")
onready var activation_label: Node2D
onready var canvas_activation_node: CanvasLayer = $CanvasLayer
onready var activator_coords: Position2D = $ActivatorCoords


signal _message_sent(msg, type)
signal _message_removed
signal send_data(data_obj)
signal show_label
signal hide_label
signal start_activation
signal stop_activation


func _ready() -> void:
	get_tree().paused = false
	$EntranceBarSound._set_playing(true)
	Global._check_modifier_active()
	_message = Lists.level_messages["entrance_closed"]
	spawn_node = dungeon_lvl.get_node("YSort")
	_spawn_player()
	SaveLoad.save_game()


func _connect_activation_signals(target_node: Node2D) -> void:
	for signal_item in signals_dictionary:
		var signal_i = signals_dictionary[signal_item].signal_title
		var conn_func =  signals_dictionary[signal_item].connected_function
		if is_connected(signal_i, target_node, conn_func) == false:
			_connect_signal(signal_i, target_node, conn_func)


func _disconnect_activation_signals(target_node: Node2D) -> void:	
	for signal_item in signals_dictionary:
		var signal_i = signals_dictionary[signal_item].signal_title
		var conn_func =  signals_dictionary[signal_item].connected_function
		if is_connected(signal_i, target_node, conn_func):
			disconnect(signal_i, target_node, conn_func)


func _spawn_player() -> void:
	var p_instance: KinematicBody2D = player.instance()
	p_instance.set_global_position(spawn_point.get_global_position())
	spawn_node.call_deferred("add_child", p_instance)

	_connect_signal("_message_sent", p_instance, "_on_message_received")
	_connect_signal("_message_removed", p_instance, "_on_message_removed")


func _on_MessageTrigger_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		activation_label = activation_indicator.instance()
		_connect_activation_signals(activation_label)
		activation_label.set_global_position(activator_coords.get_global_position())
		canvas_activation_node.add_child(activation_label)
		
		body.is_interactive = true
		body.interactive_obj = self
		emit_signal("send_data", item_data)
		emit_signal("show_label")


func _on_MessageTrigger_body_exited(body):
	if body.name == 'Player':
		body.is_interactive = false
		
		emit_signal("_message_removed")
		emit_signal("hide_label")
		emit_signal("stop_activation")
		
		_disconnect_activation_signals(activation_label)
		activation_label.queue_free()


func start_activation() -> void:
	emit_signal("start_activation")


func abort_activation() -> void:
	emit_signal("stop_activation")


func activate() -> void:
	emit_signal("_message_sent", _message, 1)
	activation_label.visible = false
	_disconnect_activation_signals(activation_label)


func _connect_signal(signal_title: String, target_node: Node2D, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
