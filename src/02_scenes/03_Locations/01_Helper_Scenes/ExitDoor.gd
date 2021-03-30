extends Node2D

var activation_indicator: PackedScene = preload("res://src/02_scenes/01_UI/06_InterractionIndicator/InterractionIndicator.tscn")

var has_key: bool = false
var gate_opened: bool = false
var _message: String

var item_data: Dictionary = {
	"title": "Dark Passage",
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

onready var dungeon_lvl: Node2D = get_parent()
onready var sprite: AnimatedSprite = $Sprite
onready var activation_label: Node2D
onready var canvas_activation_node: CanvasLayer = $CanvasLayer
onready var activator_coords: Position2D = $ActivatorCoords
onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

signal floor_cleared
signal _message_sent(msg, type)
signal _message_removed
signal send_data(data_obj)
signal show_label
signal hide_label
signal start_activation
signal stop_activation


func _ready() -> void:
	sprite.play("closed")
	_connect_signal("floor_cleared", LvlSummary, "_on_lvl_ended")


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


func _on_gate_opened() -> void:
	sprite.play("opening")
	audio_player._set_playing(true)
	gate_opened = true
	yield(get_tree().create_timer(0.6), "timeout")
	_load_next_lvl()


func _load_next_lvl() -> void:
	get_tree().paused = true
	Backdrop.fade_in()
	yield(Backdrop.get_node("AnimationPlayer"), "animation_finished")
	emit_signal("floor_cleared")


func _on_MessageTrigger_body_entered(body) -> void:
	if body.name == 'Player':
		_connect_signal("_message_sent", body, "_on_message_received")
		_connect_signal("_message_removed", body, "_on_message_removed")
		has_key = body.loot_management.has_key
		body.can_open = true
		
		activation_label = activation_indicator.instance()
		_connect_activation_signals(activation_label)
		activation_label.set_global_position(activator_coords.get_global_position())
		canvas_activation_node.add_child(activation_label)
		
		body.is_interactive = true
		body.interactive_obj = self
		emit_signal("send_data", item_data)
		emit_signal("show_label")


func _on_MessageTrigger_body_exited(body) -> void:
	if body.name == 'Player':
		body.is_interactive = false
		
		emit_signal("_message_removed")
		emit_signal("hide_label")
		emit_signal("stop_activation")
		emit_signal("_message_removed")
		
		body.can_open = false
		_disconnect_activation_signals(activation_label)
		activation_label.queue_free()



func start_activation() -> void:
	emit_signal("start_activation")


func abort_activation() -> void:
	emit_signal("stop_activation")


func activate() -> void:
	match has_key:
		true:
			emit_signal("_message_sent", Lists.level_messages["have_key"], 2)
		false:
			if gate_opened == false:
				emit_signal("_message_sent", Lists.level_messages["no_key"], 1)
	activation_label.visible = false
	_disconnect_activation_signals(activation_label)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)

