extends Node2D

enum SWORD_POSITIONS {
	LEFT,
	RIGHT
}

var starting_sword_position: int
var start_swing_point: Vector2
var final_swing_point: Vector2

onready var tween: Tween = get_node('../../Tween')
onready var weapon: Node2D = get_node('../../Weapon')
onready var sword: Node2D = get_node('../../Weapon/SwordItem/Sword')
onready var left_point: Position2D = get_node('../../Weapon/SwordItem/SwingRadius/LeftPosition')
onready var right_point: Position2D = get_node('../../Weapon/SwordItem/SwingRadius/RightPosition')


func _ready() -> void:
	set_physics_process(true)
	starting_sword_position = SWORD_POSITIONS.LEFT


func _physics_process(_delta) -> void:
	_check_swing_limits()
	_check_weapon_position()


func _check_weapon_position() -> void:
	weapon.look_at(get_global_mouse_position())
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
	_change_weapon_collision()
	tween.interpolate_method(sword, "look_at", start_swing_point, final_swing_point, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	match starting_sword_position:
		SWORD_POSITIONS.LEFT:
			starting_sword_position = SWORD_POSITIONS.RIGHT
		SWORD_POSITIONS.RIGHT:
			starting_sword_position = SWORD_POSITIONS.LEFT
	
	yield(tween, "tween_all_completed")
	_change_weapon_collision()


func _change_weapon_collision() ->  void:
	sword.get_node("HitBox").visible = not sword.get_node("HitBox").visible


func _input(event) -> void:
	if event.is_action_pressed("attack"):
		_weapon_swing()
