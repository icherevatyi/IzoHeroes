extends KinematicBody2D

export var health_is_damaged: bool = false
export var speed: int = 120


var movement: Vector2 = Vector2(0, 0)
var is_bored: bool = false
var is_dead:  bool = false
var has_lvl_key: bool = false
var can_open: bool = false
var door_scene: Node2D = null

onready var state_scripts: Node2D = $AdditionalScripts/StateManagement
onready var health_scripts: Node2D = $AdditionalScripts/HealthManagement
onready var loot_management: Node2D = $AdditionalScripts/LootManagement
onready var HUD = $HUD
onready var idle_timer: Timer = $Timers/IdleTimer
onready var weapon_container: Node2D = $Weapon
onready var current_weapon: Area2D = $Weapon/Sword
onready var pickup_detection_range: Area2D = $PickupDetectionRange

signal weapon_swing
signal damage_receive(dmg)
signal damage_heal(dmg)
signal show_message(msg)
signal use_bottle
signal hide_message
signal open_door

func _ready() -> void:
	_connect_signal("damage_receive", health_scripts, "_on_damage_taken")
	_connect_signal("damage_heal", health_scripts, "_on_damage_healed")
	_connect_signal("damage_receive", HUD, "_on_damage_displayed")
	_connect_signal("damage_heal", HUD, "_on_healing_displayed")
	_connect_signal("show_message", HUD, "_on_message_shown")
	_connect_signal("hide_message", HUD, "_on_message_hidden")
	_connect_signal("use_bottle", HUD, "_on_bottle_used")
	_connect_signal("use_bottle", loot_management, "_on_bottle_used")
	_connect_signal("weapon_swing", current_weapon, "_on_weapon_swing")


func _physics_process(_delta) -> void:
	if is_dead == false:
		_move_player()
		_check_mouse_position()
		weapon_container.look_at(get_global_mouse_position())

	state_scripts.monitor_states()


func _move_player() ->  void:
	movement.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movement.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	movement = movement * speed
	movement = move_and_slide(movement, Vector2(0, 0))


func _input(event) -> void:		
	if is_dead == false:
		if event.is_action_pressed("attack"):
			emit_signal("weapon_swing")
		
		if event.is_pressed() == false:
			match idle_timer.is_stopped():
				true:
					idle_timer.start()
		if event.is_pressed() == true:
			idle_timer.stop()
			is_bored = false
			
		if event.is_action_pressed("interract"):
			if can_open == true:
				emit_signal("open_door")
		
		if health_scripts.health_current < health_scripts.health_max:
			if event.is_action_pressed("use_item"):
				print(get_position())
				if loot_management.healing_bottle > 0:
					emit_signal("damage_heal", 1)
					emit_signal("use_bottle")
					loot_management.healing_bottle = max(0, loot_management.healing_bottle)
				


func _check_mouse_position() -> void:
	var min_mouse_distance: int = $CollisionShape2D.get_shape().radius
	var distance_to_player: int = int(get_global_mouse_position().x - get_global_position().x)
	
	if is_dead == false and is_bored == false:
		if distance_to_player > min_mouse_distance:
			$Sprite.flip_h = false
		if distance_to_player < min_mouse_distance:
			$Sprite.flip_h = true


func _on_message_received(msg: String) -> void:
	emit_signal("show_message", msg)


func _on_message_removed() -> void:
	emit_signal("hide_message")
	

func _damage_taken(damage: int) -> void:
	emit_signal("damage_receive", damage)


func _on_IdleTimer_timeout() -> void:
	is_bored = true


func _on_data_request_received() -> void:
	ResourceStorage.player_data.health_current = health_scripts.health_current
	ResourceStorage.player_data.coins_count = loot_management.gold_coins
	ResourceStorage.player_data.healing_pots_count = loot_management.healing_bottle


func _on_item_data_received(data) -> void:
	loot_management.process_received_loot_data(data)



func _on_DoorOpeningRange_area_entered(area):
	if area.name == "ExitTrigger":
		_connect_signal("open_door", area.get_parent(), "_on_gate_opened")
		can_open = true


func _on_DoorOpeningRange_area_exited(area):
	if area.name == "ExitTrigger":
		door_scene = null
		var _message_placeholder = disconnect("open_door", area.get_parent(), "_on_gate_opened")
		can_open = false


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
