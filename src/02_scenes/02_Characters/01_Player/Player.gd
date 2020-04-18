extends KinematicBody2D

export var health_is_damaged: bool = false
export var speed: int = 120

var movement: Vector2 = Vector2(0, 0)

onready var state_scripts: Node2D = $AdditionalScripts/StateManagement
onready var health_scripts: Node2D = $AdditionalScripts/HealthManagement

onready var HUD = $HUD

signal damage_receive(dmg)
signal damage_heal(dmg)


func _ready() -> void:
	_connect_signal("damage_receive", health_scripts, "_on_damage_taken")
	_connect_signal("damage_receive", HUD, "_on_damage_displayed")
	_connect_signal("damage_heal", HUD, "_on_healing_displayed")


func _physics_process(_delta) -> void:
	_move_player()
	state_scripts.monitor_states()


func _move_player() ->  void:
	movement.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movement.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	movement = movement * speed
	movement = move_and_slide(movement, Vector2(0, 0))


func _input(event) -> void:
	if event.is_action_pressed("move_left"):
		$Sprite.flip_h = true
	if event.is_action_pressed("move_right"):
		$Sprite.flip_h = false

	if event.is_action_pressed("ui_accept"):
		_damage_taken(2)

func _on_message_received(msg: String) -> void:
	print(msg)


func _damage_taken(damage: int):
	emit_signal("damage_receive", damage)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
