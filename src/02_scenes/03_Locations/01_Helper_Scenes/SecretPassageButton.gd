extends Area2D

var activation_indicator: PackedScene = preload("res://src/02_scenes/01_UI/06_InterractionIndicator/InterractionIndicator.tscn")

var _response: int
var is_usable: bool = true
var player_obj

var item_data: Dictionary = {
	"title": "Pressing Plate",
	"type": "bed"
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

onready var activation_label: Node2D
onready var canvas_activation_node: CanvasLayer = $CanvasLayer
onready var activator_coords: Position2D = $ActivatorCoords
onready var animated_sprite: Sprite = $Sprite
onready var btn_animation_player: AnimationPlayer = $ButtonAnimationPlayer
onready var particles: Particles2D = $Sparks

signal send_data(data_obj)
signal show_label
signal hide_label
signal start_activation
signal stop_activation
signal secret_button_pressed


func _ready() -> void:	
	_response = connect("secret_button_pressed", get_parent(), "_on_secret_button_pressed")
	btn_animation_player.play("idle")
	particles.set_emitting(false)


func show_sparkles() -> void:
	particles.set_emitting(true)
	

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


func _on_SecretPassageButton_body_entered(body) -> void:
	if body.name == "Player":
		if is_usable == true:
			activation_label = activation_indicator.instance()
			_connect_activation_signals(activation_label)
			activation_label.set_global_position(activator_coords.get_global_position())
			canvas_activation_node.add_child(activation_label)
			
			body.is_interactive = true
			player_obj = body
			emit_signal("send_data", item_data)
			emit_signal("show_label")
		body.interactive_obj = self


func _on_SecretPassageButton_body_exited(body) -> void:
	if body.name == "Player":
		player_obj = null
		body.is_interactive = false
		if is_usable == true:
			emit_signal("hide_label")
			emit_signal("stop_activation")
			
			_disconnect_activation_signals(activation_label)
			activation_label.queue_free()


func start_activation() -> void:
	particles.set_emitting(false)
	emit_signal("start_activation")


func abort_activation() -> void:
	emit_signal("stop_activation")


func activate() -> void:
	$AudioStreamPlayer._set_playing(true)
	for body in get_overlapping_bodies():
		if body.name == "Player":
			if is_usable == true:
				activation_label.visible = false
				is_usable = false
				btn_animation_player.play("activation")
				body.interactive_obj = null
				_disconnect_activation_signals(activation_label)


func activated() -> void:
	emit_signal("secret_button_pressed")
