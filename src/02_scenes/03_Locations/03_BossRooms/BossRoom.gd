extends Node2D

var _response: int

var tween_time: float = 2.0
var tween_ease := Tween.EASE_IN_OUT
var tween_trans := Tween.TRANS_LINEAR

var secret_door_start_position: Vector2 = Vector2(4, -112)
var secret_door_end_position: Vector2 = Vector2(63, -112)

var darkness_enabled: Color = Color(0, 0, 0, 0.9)
var darkness_disabled: Color = Color(0, 0, 0, 0)

var throne_top_start_position: Vector2 = Vector2(0, -102)
var throne_top_end_position: Vector2 = Vector2(0, -92)

var throne_bottom_start_position: Vector2 = Vector2(0, -77)
var throne_bottom_end_position: Vector2 = Vector2(0, -67)

onready var throne_top: Sprite = $TopPart
onready var throne_bottom: StaticBody2D = $Throne
onready var secret_door: StaticBody2D = $SecretDoor
onready var secret_corridor_darkness: ColorRect = $SecretCorridorDarkness 
onready var secret_door_tween: Tween = $SecretDoorTween
onready var darkness_removal_tween: Tween = $DarknessRemoval
onready var throne_top_moving_tween: Tween = $ThroneTopMover
onready var throne_bottom_moving_tween: Tween = $ThroneBottomMover
onready var boss: KinematicBody2D = $YSort/Boss



func _ready() -> void:
	secret_corridor_darkness.modulate = darkness_enabled
	Backdrop.fade_out()


func _on_secret_door_opened() -> void:
	_response = secret_door_tween.interpolate_property(secret_door, "position", secret_door_start_position, secret_door_end_position, tween_time, tween_trans, tween_ease)
	_response = darkness_removal_tween.interpolate_property(secret_corridor_darkness, "modulate", darkness_enabled, darkness_disabled, tween_time, tween_trans, tween_ease)
	_response = throne_top_moving_tween.interpolate_property(throne_top, "position", throne_top_start_position, throne_top_end_position, tween_time, tween_trans, tween_ease)
	_response = throne_bottom_moving_tween.interpolate_property(throne_bottom, "position", throne_bottom_start_position, throne_bottom_end_position, tween_time, tween_trans, tween_ease)
	
	_response = throne_top_moving_tween.start()
	_response = throne_bottom_moving_tween.start()
	yield(get_tree().create_timer(1), "timeout")
	_response = secret_door_tween.start()
	_response = darkness_removal_tween.start()
