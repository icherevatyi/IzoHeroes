extends Node2D

var activation_indicator: PackedScene = preload("res://src/02_scenes/01_UI/06_InterractionIndicator/InterractionIndicator.tscn")

var _response: int
var is_usable: bool = true

var signals_dictionary = {
		0: {
			"signal_title": "show_label",
			"connected_function": "_on_indicator_enabled"
		},
		1: {
			"signal_title": "hide_label",
			"connected_function": "_on_indicator_disabled"
			},
		2: {
			"signal_title": "start_activation",
			"connected_function": "_on_activation_started"
		},
		3: {
			"signal_title": "stop_activation",
			"connected_function": "_on_activation_stopped"
		},
	}

onready var activation_label: Node2D
onready var canvas_activation_node: CanvasLayer = $CanvasLayer
onready var activator_coords: Position2D = $ActivatorCoords
onready var bag_not_used: Node2D = $NotUsed
onready var bag_used: Node2D = $Used

signal show_label
signal hide_label
signal start_activation
signal stop_activation


func _ready() -> void:	
	bag_not_used.visible = true
	bag_used.visible = false


func _connect_activation_signals(target_node: Node2D) -> void:
	_response = connect("show_label", target_node, "_on_indicator_enabled")
	_response = connect("hide_label", target_node, "_on_indicator_disabled")
	_response = connect("start_activation", target_node, "_on_activation_started")
	_response = connect("stop_activation", target_node, "_on_activation_stopped")


func _disconnect_activation_signals(target_node: Node2D) -> void:	
	for signal_item in signals_dictionary:
		var signal_i = signals_dictionary[signal_item].signal_title
		var conn_func =  signals_dictionary[signal_item].connected_function
		if is_connected(signal_i, target_node, conn_func):
			disconnect(signal_i, target_node, conn_func)


func _on_PlayerCollisionDetector_body_entered(body) -> void:
	if body.name == "Player":
		if is_usable == true:
			activation_label = activation_indicator.instance()
			_connect_activation_signals(activation_label)
			activation_label.set_global_position(activator_coords.get_global_position())
			canvas_activation_node.add_child(activation_label)
			
			body.is_interactive = true
			emit_signal("show_label")
		body.interactive_obj = self


func _on_PlayerCollisionDetector_body_exited(body) -> void:
	if body.name == "Player":
		body.is_interactive = false
		body.interactive_obj = null
		if is_usable == true:
			emit_signal("hide_label")
			emit_signal("stop_activation")
		
			_disconnect_activation_signals(activation_label)
			activation_label.queue_free()



func start_activation() -> void:
	emit_signal("start_activation")


func abort_activation() -> void:
	emit_signal("stop_activation")


func activate() -> void:
	for body in $PlayerCollisionDetector.get_overlapping_bodies():
		if body.name == "Player":
			if is_usable == true:
				emit_signal("hide_label")
				Backdrop.fade_in(2.5)
				yield(Backdrop.animation_player, "animation_finished")
				get_tree().paused = true
				body.emit_signal("damage_heal", body.health_scripts.health_max)
				is_usable = false
				bag_not_used.visible = false
				bag_used.visible = true
				get_tree().paused = false
				Backdrop.fade_out()
				_disconnect_activation_signals(activation_label)

func show_inactive_message() -> void:
	print("There's no time to rest!")
