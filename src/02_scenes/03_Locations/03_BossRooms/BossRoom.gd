extends Node2D

var _response: int
var _amulet_taken: bool = false


var tween_time: float = 2.0
var tween_ease := Tween.EASE_IN_OUT
var tween_trans := Tween.TRANS_LINEAR

var secret_door_start_position: Vector2 = Vector2(4, -112)
var secret_door_end_position: Vector2 = Vector2(63, -112)

var darkness_enabled: Color = Color(0, 0, 0, 0.9)
var darkness_disabled: Color = Color(0, 0, 0, 0)

var throne_start_position: Vector2 = Vector2(0, -92)
var throne_end_position: Vector2 = Vector2(0, -82)
var voice_played: bool = false

onready var secret_passage_button: Area2D = $SecretPassageButton
onready var throne: StaticBody2D = $YSort/Throne
onready var secret_door: StaticBody2D = $SecretDoor
onready var secret_corridor_darkness: ColorRect = $SecretCorridorDarkness 
onready var secret_door_tween: Tween = $SecretDoorTween
onready var darkness_removal_tween: Tween = $DarknessRemoval
onready var throne_moving_tween: Tween = $ThroneMover
onready var boss: KinematicBody2D = $YSort/Boss

onready var nav_2d: Navigation2D = $Navigation2D
onready var return_for_amulet_point: Position2D = $ReturnForAmuletPoint
onready var cutscene_end_point: Position2D = $EndPointCoords

signal endgame_message_sent


func _ready() -> void:
	secret_corridor_darkness.modulate = darkness_enabled
	Backdrop.fade_out()


func _on_boss_died() -> void:
	secret_passage_button.show_sparkles()
	
	var player: KinematicBody2D = $YSort/Player
	player.show_message("A key? I don't see any door. Perhaps there should be some secret passage...should take a look near the throne!", 5)


func _on_secret_door_opened() -> void:
	_response = secret_door_tween.interpolate_property(secret_door, "position", secret_door_start_position, secret_door_end_position, tween_time, tween_trans, tween_ease)
	_response = darkness_removal_tween.interpolate_property(secret_corridor_darkness, "modulate", darkness_enabled, darkness_disabled, tween_time, tween_trans, tween_ease)
	_response = throne_moving_tween.interpolate_property(throne, "position", throne_start_position, throne_end_position, tween_time, tween_trans, tween_ease)
	
	_response = throne_moving_tween.start()
	_response = throne_moving_tween.start()
	yield(get_tree().create_timer(1), "timeout")
	_response = secret_door_tween.start()
	_response = darkness_removal_tween.start()
	$BGMumble.play()


func _on_amulet_pickup() -> void:
	_amulet_taken = true
	var player: KinematicBody2D = $YSort/Player
	$ShockwavePlayer.play("launch_wave")
	player.hide_HUD()
	yield(get_tree().create_timer(1), "timeout")
	var new_path = nav_2d.get_simple_path(player.get_global_position(), cutscene_end_point.get_global_position(), false)
	player.automove_path = new_path


func _on_Area2D_body_entered(body) -> void:
	if body.name == "Player":
		match _amulet_taken:
			false:
				_return_for_amulet()
			true:
				_end_demo()


func _on_Area2D2_body_entered(body) -> void:
	if body.name == "Player" and voice_played == false:
		$DemonicVoice.play()
		voice_played = true


func _return_for_amulet() -> void:
	var player: KinematicBody2D = $YSort/Player
	var new_path = nav_2d.get_simple_path(player.get_global_position(), return_for_amulet_point.get_global_position(), false)
	player.automove_path = new_path
	player.show_message("The amulet, it calls me. I NEED IT.")


func _end_demo() -> void:
	var _message = Lists.level_messages["demo_end"]
	_connect_signal("endgame_message_sent", LvlSummary, "_end_demo_reached")
	Backdrop.fade_in()
	yield(Backdrop.get_node("AnimationPlayer"), "animation_finished")
	get_tree().paused = true
	emit_signal("endgame_message_sent")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
