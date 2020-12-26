extends KinematicBody2D

var is_taking_damage: bool = false
var is_attacking: bool = false

var is_boss: bool = false
var is_main_boss: bool = false
var going_rage: bool = false
var is_enraged: bool = false
var type: String
var health_current: float
var health_max: float
var damage: int
var _damage_multiplier: int = 1
var is_dead: bool = false
var drops_key: bool = false
var player_coords: Vector2
var player_visible: bool = false

onready var detection_range: Area2D = $DetectionRange
onready var attack_range: Area2D = $AttackRange
onready var attack_scripts: Node2D = $AdditionalScripts/AttackManagement
onready var movement_scripts: Node2D = $AdditionalScripts/MovementManagement
onready var state_scripts: Node2D = $AdditionalScripts/StatesManagement
onready var loot_scripts: Node2D = $AdditionalScripts/LootManagement
onready var movement_timer: Timer = $Timers/MovementChangeTimer
onready var health_bars: Node2D = $HealthBars
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hurtbox_collision: CollisionShape2D = $HurtBox/CollisionShape2D
onready var player_position_update_timer: Timer = $PlayerPositionUpdate

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
						is_player_visible(body)
						if is_in_attack_range and player_visible == true:
							movement_scripts._face_player(player_coords)
							attack_scripts._aim_at_player(player_coords)
						else:
							match is_attacking:
								false:
									movement_scripts.chase_player(player_coords)
								true:
									movement_scripts.velocity = Vector2.ZERO

		movement = move_and_slide(movement_scripts.velocity, Vector2(0, 0))


func is_player_visible(body) -> void:
	var space_state = get_world_2d().direct_space_state
	var result =  space_state.intersect_ray(position, body.position, [self], collision_mask)
	if result:
		if result.collider.name == "Player":
			player_visible = true
			hurtbox_collision.disabled = false
			Global.is_dangerous_to_interact = true
			
		else:
			player_visible = false
			hurtbox_collision.disabled = true
			Global.is_dangerous_to_interact = false


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
	if is_boss == false and is_main_boss == false:
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
		Global.is_dangerous_to_interact = false
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
		player_position_update_timer.start()
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


func _on_PlayerPositionUpdate_timeout():
	for body in detection_range.get_overlapping_bodies():
		if body.name == "Player" and is_chasing == true:
			player_coords = body.get_global_position()
