extends KinematicBody2D

export var is_taking_damage: bool = false
export var is_attacking: bool = false

var is_boss: bool = false
var type: String
var health_current: float
var health_max: float
var damage: int
var _damage_multiplier: int = 1
var is_dead: bool = false
var drops_key: bool = false
var player_coords: Vector2

onready var detection_range: Area2D = $DetectionRange
onready var attack_range: Area2D = $AttackRange
onready var attack_scripts: Node2D = $AdditionalScripts/AttackManagement
onready var movement_scripts: Node2D = $AdditionalScripts/MovementManagement
onready var state_scripts: Node2D = $AdditionalScripts/StatesManagement
onready var loot_scripts: Node2D = $AdditionalScripts/LootManagement
onready var movement_timer: Timer = $Timers/MovementChangeTimer
onready var health_bars: Node2D = $HealthBars
onready var animation_player: AnimationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()
var movement
var is_in_attack_range: bool = false
var is_chasing: bool = false

signal initiate_healthpool(health_maximum)
signal manage_healthbar_change(hp_before_damage, hp_after_damage)


func _ready() -> void:
	add_to_group("Enemies")
	_connect_signal("manage_healthbar_change", health_bars, "_on_healthbar_updated")
	_connect_signal("initiate_healthpool", health_bars, "_on_healthbar_initiated")
	emit_signal("initiate_healthpool", health_max)


func _physics_process(_delta) -> void:
	state_scripts.monitor_states()
	if is_dead == false:
		match is_chasing:
			false:
				movement_scripts.move_enemy()
			true:
				for body in detection_range.get_overlapping_bodies():
					if body.name == "Player":
						if is_in_attack_range:
							movement_scripts.enemy_stop(body.get_global_position())
							attack_scripts._face_player(body.get_global_position())
						else:
							match is_attacking:
								false:
									movement_scripts.chase_player(body.get_global_position())

		movement = move_and_slide(movement_scripts.velocity, Vector2(0, 0))


func _get_stats(enemy_type: String) -> void:
	for enemy in Lists.enemy_list:
		if Lists.enemy_list[enemy].type == enemy_type:
			health_max = Lists.enemy_list[enemy].health_max * Global.hp_modifier
			health_current = health_max
			damage = Lists.enemy_list[enemy].damage


func receive_damage(damage_received) -> void:
	if (health_current - damage_received) <= 0:
		OS.delay_msec(80)
	var health_prev = health_current
	if is_boss == false:
		for stat in PlayerStats.stats_list:
			if PlayerStats.stats_list[stat].type == "instakill_chance":
				var instadeath_chance: float = PlayerStats.stats_list[stat].value
				rng.randomize()
				var result = rng.randi_range(0, 100)
				if result <= instadeath_chance:
					damage_received = health_current

	health_current -= damage_received
	health_current = int(max(0, health_current))
	emit_signal("manage_healthbar_change", health_prev, health_current)
	yield(get_tree().create_timer(0.35),"timeout")
	
	if health_current <= 0:
		_death()


func _on_miniboss_created() -> void:
	is_boss = true
	drops_key = true
	health_max = health_max * 1.8
	health_current = health_max
	damage *= 2
	
	set_scale(Vector2(1.3, 1.3))
	emit_signal("initiate_healthpool", health_max)


func _death() -> void:
	is_dead = true
	$CollisionShape2D.disabled = true
	health_bars.visible = false


func _on_DetectionRange_body_entered(body) -> void:
	if body.name == "Player":
		is_chasing = true


func _on_DetectionRange_body_exited(body) -> void:
	if body.name == "Player":
		is_chasing = false


func _on_AttackRange_body_entered(body) -> void:
	if body.name == "Player":
		is_in_attack_range = true
		player_coords = body.get_global_position()


func _on_AttackRange_body_exited(body) -> void:
	if body.name == "Player":
		is_in_attack_range = false


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
