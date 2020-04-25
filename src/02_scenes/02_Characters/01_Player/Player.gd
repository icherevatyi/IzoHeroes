extends KinematicBody2D

export var health_is_damaged: bool = false
export var speed: int = 120


var movement: Vector2 = Vector2(0, 0)
var is_bored: bool = false
var is_dead:  bool = false

onready var state_scripts: Node2D = $AdditionalScripts/StateManagement
onready var health_scripts: Node2D = $AdditionalScripts/HealthManagement

onready var HUD = $HUD
onready var idle_timer: Timer = $Timers/IdleTimer

onready var weapon: Node2D  = $Weapon/SwordItem

signal weapon_swing
signal damage_receive(dmg)
signal damage_heal(dmg)


func _ready() -> void:
	_connect_signal("damage_receive", health_scripts, "_on_damage_taken")
	_connect_signal("damage_receive", HUD, "_on_damage_displayed")
	_connect_signal("damage_heal", HUD, "_on_healing_displayed")
	_connect_signal("weapon_swing", weapon, "_on_weapon_swing_started")


func _physics_process(_delta) -> void:
	_move_player()
	_check_mouse_position()
	state_scripts.monitor_states()
	weapon.look_at(get_global_mouse_position())


func _move_player() ->  void:
	movement.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movement.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	movement = movement * speed
	movement = move_and_slide(movement, Vector2(0, 0))


func _input(event) -> void:		
	if event.is_action_pressed("ui_accept"):
		_damage_taken(2)
	if event.is_action_pressed("attack"):
		emit_signal("weapon_swing")
		
	if event.is_pressed() == false:
		match idle_timer.is_stopped():
			true:
				idle_timer.start()
	if event.is_pressed() == true:
		idle_timer.stop()
		is_bored = false


func _check_mouse_position() -> void:
	var min_mouse_distance: int = $CollisionShape2D.get_shape().radius
	var distance_to_player: int = int(get_global_mouse_position().x - get_global_position().x)
	
	if is_dead == false and is_bored == false:
		if distance_to_player > min_mouse_distance:
			$Sprite.flip_h = false
		if distance_to_player < min_mouse_distance:
			$Sprite.flip_h = true
		

func _on_message_received(msg: String) -> void:
	print(msg)


func _damage_taken(damage: int) -> void:
	emit_signal("damage_receive", damage)


func _on_IdleTimer_timeout() -> void:
	is_bored = true


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
