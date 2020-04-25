extends Node2D

enum SWORD_POSITIONS {
	LEFT,
	RIGHT
}

var starting_sword_position: int
var start_swing_point: Vector2
var final_swing_point: Vector2

var damage: int = 35
var hitbox_availability: bool = false

onready var tween: Tween = $Tween
onready var sword: Node2D = $Sword
onready var hitbox: Area2D = $HitBox
onready var left_point: Position2D = $SwingRadius/LeftPosition
onready var right_point: Position2D = $SwingRadius/RightPosition

signal do_damage(dmg)


func _ready() -> void:
	set_physics_process(true)
	starting_sword_position = SWORD_POSITIONS.LEFT
	print(hitbox.get_collision_mask_bit(2))


func _physics_process(_delta) -> void:
	_check_swing_limits()
	_check_weapon_position()


func _change_weapon_collision() -> void:
	hitbox.get_node("CollisionPolygon2D").disabled = !hitbox.get_node("CollisionPolygon2D").disabled


func _check_weapon_position() -> void:
	sword.look_at(start_swing_point)


func _check_swing_limits() -> void:
	match starting_sword_position:
		SWORD_POSITIONS.LEFT:
			start_swing_point = left_point.get_global_position()
			final_swing_point = right_point.get_global_position()
		SWORD_POSITIONS.RIGHT:
			start_swing_point = right_point.get_global_position()
			final_swing_point = left_point.get_global_position()


func _weapon_swing() -> void:
	tween.interpolate_method(sword, "look_at", start_swing_point, final_swing_point, 0.45, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
	_change_weapon_collision()
	
	match starting_sword_position:
		SWORD_POSITIONS.LEFT:
			starting_sword_position = SWORD_POSITIONS.RIGHT
		SWORD_POSITIONS.RIGHT:
			starting_sword_position = SWORD_POSITIONS.LEFT
	
	yield(tween, "tween_all_completed")
	
	_change_weapon_collision()


func _on_weapon_swing_started() -> void:
	_weapon_swing()


func _on_HitBox_area_entered(area) -> void:
	if area.name == "HurtBox":
		_connect_signal("do_damage", area, "_on_damage_received")
		if hitbox.get_collision_mask_bit(2) == true:
			emit_signal("do_damage", damage)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
