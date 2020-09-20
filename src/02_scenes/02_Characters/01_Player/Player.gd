extends KinematicBody2D

var health_is_damaged: bool = false

var rng = RandomNumberGenerator.new()
var speed: int
var movement: Vector2 = Vector2(0, 0)
var is_bored: bool = false
var is_dead:  bool = false
var can_open: bool = false
var can_attack: bool = true
var door: Node2D = null
var is_door_opened: bool = false
var enemy_visible: bool = false
var is_interactive: bool = false


var interactive_obj: Object


onready var state_scripts: Node2D = $AdditionalScripts/StateManagement
onready var health_scripts: Node2D = $AdditionalScripts/HealthManagement
onready var loot_management: Node2D = $AdditionalScripts/LootManagement
onready var HUD = $HUD
onready var idle_timer: Timer = $Timers/IdleTimer
onready var weapon_container: Node2D = $Weapon
onready var current_weapon: Area2D = $Weapon/Sword
onready var pickup_detection_range: Area2D = $PickupDetectionRange
onready var camera: Camera2D = $Camera2D


signal weapon_swing
signal use_stamina(value)
signal damage_receive(dmg)
signal damage_heal(dmg)
signal show_message(msg, type)
signal use_bottle
signal hide_message
signal use_key
signal open_gate
signal pickup_screen_blink

func _ready() -> void:
	speed = _get_stat_value("movement_speed")
	_connect_signal("damage_receive", health_scripts, "_on_damage_taken")
	_connect_signal("damage_heal", health_scripts, "_on_damage_healed")
	_connect_signal("damage_receive", HUD, "_on_damage_displayed")
	_connect_signal("damage_heal", HUD, "_on_healing_displayed")
	_connect_signal("use_stamina", HUD, "_on_stamina_used")
	_connect_signal("show_message", HUD, "_on_message_shown")
	_connect_signal("hide_message", HUD, "_on_message_hidden")
	_connect_signal("use_bottle", HUD, "_on_bottle_used")
	_connect_signal("use_key", HUD, "_on_key_used")
	_connect_signal("use_bottle", loot_management, "_on_bottle_used")
	_connect_signal("use_key", loot_management, "_on_key_used")
	_connect_signal("weapon_swing", current_weapon, "_on_weapon_swing")
	_connect_signal("use_stamina", health_scripts, "_on_stamina_used")
	_connect_signal("pickup_screen_blink", camera, "_on_screen_blinked")


func _get_stat_value(param: String) -> int:
	for key in PlayerStats.stats_list.keys():
		if PlayerStats.stats_list[key].type == param:
			return PlayerStats.stats_list[key].value
	return 0


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
			if can_attack == true:
				emit_signal("weapon_swing")
				emit_signal("use_stamina", 10)
			else:
				HUD.on_exhaustion_message_trigger()
		
		if event.is_action_pressed("view_stats"):
			HUD.toggle_char_sheet()
		
		if event.is_pressed() == false:
			match idle_timer.is_stopped():
				true:
					idle_timer.start()
		if event.is_pressed() == true:
			idle_timer.stop()
			is_bored = false
		
		if health_scripts.health_current < health_scripts.health_max:
			if event.is_action_pressed("use_item"):
				if loot_management.healing_bottle > 0:
					emit_signal("damage_heal", 30)
					emit_signal("use_bottle")
					loot_management.healing_bottle = max(0, loot_management.healing_bottle)
			if event.is_action_pressed("interract"):
				if is_interactive == true and interactive_obj != null:
					interactive_obj.activate()


func _on_stam_depleeted() -> void:
	can_attack = false


func _on_stam_restored() -> void:
	can_attack = true


func _check_mouse_position() -> void:
	var min_mouse_distance: int = $CollisionShape2D.get_shape().radius
	var distance_to_player: int = int(get_global_mouse_position().x - get_global_position().x)
	
	if is_dead == false and is_bored == false:
		if distance_to_player > min_mouse_distance:
			$Sprite.flip_h = false
		if distance_to_player < min_mouse_distance:
			$Sprite.flip_h = true


func open_gate() -> void:
	if can_open == true and loot_management.has_key == true:
		emit_signal("open_gate")
		emit_signal("use_key")
		_on_data_request_received()


func _on_message_received(msg: String, type: int) -> void:
	emit_signal("show_message", msg, type)


func _on_message_removed() -> void:
	emit_signal("hide_message")
	

func _damage_taken(damage: int) -> void:
	rng.randomize()
	var dodge_chance = 0
	for stat in PlayerStats.stats_list:
		if PlayerStats.stats_list[stat].type == "dodge_chance":
			dodge_chance = PlayerStats.stats_list[stat].value
	var result: int = rng.randi_range(0, 100)
	if result > dodge_chance:
		emit_signal("damage_receive", damage)
		camera.start_shaking(0.2, 20, 7)


func _player_staggered() -> void:
	set_physics_process(false)
	yield(get_tree().create_timer(0.5),"timeout")
	set_physics_process(true)


func _on_IdleTimer_timeout() -> void:
	is_bored = true


func _on_data_request_received() -> void:
	ResourceStorage.player_data.health_current = health_scripts.health_current
	ResourceStorage.player_data.coins_count = loot_management.gold_coins
	ResourceStorage.player_data.healing_pots_count = loot_management.healing_bottle


func _on_item_data_received(data) -> void:
	emit_signal("pickup_screen_blink")
	loot_management.process_received_loot_data(data)


func _on_DoorOpener_area_entered(area) -> void:
	if area.get_parent().name == "ExitDoor":
		_connect_signal("open_gate", area.get_parent(), "_on_gate_opened")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)

