extends KinematicBody2D

export var speed: int = 120
var movement: Vector2 = Vector2(0, 0)

onready var state_scripts: Node2D = $AdditionalScripts/StateManagement

onready var HUD = $HUD

# Health Section
var health_current: int = 4
var health_max: int = 8
var health_min: int = 0

signal change_state(state)
signal damage_receive(dmg)
signal damage_heal(dmg)


func _ready() -> void:
	_connect_signal("change_state", state_scripts, "_on_state_changed")
	_connect_signal("damage_receive", HUD, "_on_damage_taken")
	_connect_signal("damage_heal", HUD, "_on_health_restored")


func _physics_process(_delta) -> void:
	_move_player()


func _move_player() ->  void:
	movement.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movement.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	movement = movement * speed
	movement = move_and_slide(movement, Vector2(0, 0))
	
	if movement != Vector2(0, 0):
		emit_signal("change_state", state_scripts.STATE_VALUES.WALK)
	if movement == Vector2(0, 0):
		emit_signal("change_state", state_scripts.STATE_VALUES.IDLE_1)	


func _input(event) -> void:
	if event.is_action_pressed("move_left"):
		$Sprite.flip_h = true
	if event.is_action_pressed("move_right"):
		$Sprite.flip_h = false
		
	if event.is_action_pressed("ui_accept"):
		_take_damage(3)


func _take_damage(damage) -> void:
	health_current -= damage
	emit_signal("damage_receive", damage)
	emit_signal("change_state", state_scripts.STATE_VALUES.RECEIVE_DAMAGE)
	if health_current <= 0:
		player_died()
	health_current = int(max(0, health_current))


func player_died() -> void:
	emit_signal("change_state", state_scripts.STATE_VALUES.DEATH)
	


func _on_message_received(msg: String) -> void:
	print(msg)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
