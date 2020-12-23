extends RigidBody2D

var activation_indicator: PackedScene = preload("res://src/02_scenes/01_UI/06_InterractionIndicator/InterractionIndicator.tscn")

var _response: int
var weapon_data: Dictionary
var weapon_type: String

var direction_list: Dictionary = {
	0: Vector2(0, -150),
	1: Vector2(0, 150),
	2: Vector2(150, 0),
	3: Vector2(-150, 0)
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

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var activator_coords: Position2D = $ActivatorCoords
onready var activation_label: Node2D
onready var canvas_activation_node: CanvasLayer = $CanvasLayer

signal send_data(current_wep_obj, data_obj)
signal show_label
signal hide_label
signal start_activation
signal stop_activation
signal take_weapon(weapon_type, weapon_position)


func _ready() -> void:
	apply_central_impulse(_select_direction())


func _connect_activation_signals(target_node: Node2D) -> void:
	for signal_item in signals_dictionary:
		var signal_i = signals_dictionary[signal_item].signal_title
		var conn_func =  signals_dictionary[signal_item].connected_function
		if is_connected(signal_i, target_node, conn_func) == false:
			_response = connect(signal_i, target_node, conn_func)


func _disconnect_activation_signals(target_node: Node2D) -> void:	
	for signal_item in signals_dictionary:
		var signal_i = signals_dictionary[signal_item].signal_title
		var conn_func =  signals_dictionary[signal_item].connected_function
		if is_connected(signal_i, target_node, conn_func):
			disconnect(signal_i, target_node, conn_func)


func _on_Timer_timeout() -> void:
	sleeping = true
	set_collision_layer_bit(3, true)


func _select_direction() -> Vector2:
	rng.randomize()
	var rand_dir = rng.randi_range(0, 3)
	return direction_list[rand_dir]


func _on_PlayerCollisionDetector_body_entered(body) -> void:
	if body.name == "Player":
		activation_label = activation_indicator.instance()
		_connect_activation_signals(activation_label)
		activation_label.set_global_position(activator_coords.get_global_position())
		canvas_activation_node.add_child(activation_label)
		body.is_interactive = true
		body.interactive_obj = self
		emit_signal("send_data", body.current_weapon.weapon_type, Lists.weapon_list[weapon_type])
		emit_signal("show_label")


func _on_PlayerCollisionDetector_body_exited(body) -> void:
	if body.name == "Player":
		body.is_interactive = false
		body.interactive_obj = null
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
			_response = connect("take_weapon", body, "_on_weapon_taken")
			
			emit_signal("hide_label")
			emit_signal("take_weapon", weapon_type, get_global_position())

			_disconnect_activation_signals(activation_label)
			call_deferred("queue_free")
