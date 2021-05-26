extends Node2D

var phrase_item_package: PackedScene = load("res://src/02_scenes/01_UI/01_Elements/Notification/AmuletPhraseItem.tscn")
var boss_alive: bool = true

var _response: int
var _amulet_taken: bool = false

var curr_track: int
var old_track: int

var tween_time: float = 2.0
var tween_ease := Tween.EASE_IN_OUT
var tween_trans := Tween.TRANS_LINEAR

var secret_door_start_position: Vector2 = Vector2(4, -112)
var secret_door_end_position: Vector2 = Vector2(63, -112)

var darkness_enabled: Color = Color(0, 0, 0, 0.9)
var darkness_disabled: Color = Color(0, 0, 0, 0)

var throne_start_position: Vector2 = Vector2(0, -92)
var throne_end_position: Vector2 = Vector2(0, -82)
var phrase_generator_enabled: bool = false

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var secret_passage_button: Area2D = $SecretPassageButton
onready var throne: StaticBody2D = $YSort/Throne
onready var secret_door: StaticBody2D = $SecretDoor
onready var secret_corridor_darkness: ColorRect = $SecretCorridorDarkness 
onready var secret_door_tween: Tween = $SecretDoorTween
onready var darkness_removal_tween: Tween = $DarknessRemoval
onready var throne_moving_tween: Tween = $ThroneMover
onready var boss: KinematicBody2D = $YSort/Boss

onready var nav_2d: Navigation2D = $Navigation2D
onready var cutscene_end_point: Position2D = $EndPointCoords

onready var phrases_container: Control = $ShockwaveLayer/AmuletPhrasesContainer
onready var phrase_timer: Timer = $ShockwaveLayer/AmuletPhrasesContainer/Timer

onready var environment_sound_player: AudioStreamPlayer = $Env_Sounds

onready var music_player: AudioStreamPlayer = $Music
onready var music_volume_tween: Tween = $MusicSoundTweakTween

signal game_ended
signal _on_music_selected(author)
signal _init_phrase(phrase)


func _ready() -> void:
	secret_corridor_darkness.modulate = darkness_enabled
	Backdrop.fade_out()
	phrase_generator_enabled = true


func _on_boss_died() -> void:
	boss_alive = false
	secret_passage_button.show_sparkles()
	music_volume_tween.interpolate_property(music_player, "volume_db", 5, -200, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	music_volume_tween.start()


func _open_passage() -> void:
	var player: KinematicBody2D = $YSort/Player
	
	_response = secret_door_tween.interpolate_property(secret_door, "position", secret_door_start_position, secret_door_end_position, tween_time, tween_trans, tween_ease)
	_response = darkness_removal_tween.interpolate_property(secret_corridor_darkness, "modulate", darkness_enabled, darkness_disabled, tween_time, tween_trans, tween_ease)
	_response = throne_moving_tween.interpolate_property(throne, "position", throne_start_position, throne_end_position, tween_time, tween_trans, tween_ease)
	
	_response = throne_moving_tween.start()
	_response = secret_door_tween.start()
	_response = darkness_removal_tween.start()
	
	environment_sound_player.set_stream(Lists.slide_wall_snd)
	environment_sound_player._set_playing(true)
	player.camera.start_shaking(2, 30, 1.5)


func _on_secret_button_pressed() -> void:
	var player: KinematicBody2D = $YSort/Player
	$ShockwavePlayer.play("launch_wave")
	player.show_message("What...what's happening?", 2.3)
	
	yield(get_tree().create_timer(1), "timeout")
	player.hide_HUD()
	_start_phrases_spawn()
	intensify_mumble()
	yield(get_tree().create_timer(1), "timeout")
	_open_passage()
	
	
	yield(get_tree().create_timer(2.3), "timeout")
	var new_path = nav_2d.get_simple_path(player.get_global_position(), cutscene_end_point.get_global_position(), false)
	player.automove_path = new_path
	


func _on_amulet_pickup() -> void:
	_amulet_taken = true
	var player: KinematicBody2D = $YSort/Player
	player._play_item_pickup()
	player.show_message("Ah! Here it is! Now I need to find a way out. There should be some secret tunnel or something, may take a look near the throne.", 8)


func intensify_mumble() -> void:
	$BGMumble.play()
	music_volume_tween.interpolate_property($BGMumble, "volume_db", 5, 15, 3.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	music_volume_tween.start()


func _on_Area2D2_body_entered(body) -> void:
	if body.name == "Player":
		_end_demo()


func _end_demo() -> void:
	_connect_signal("game_ended", LvlSummary, "_end_game_reached")
	Backdrop.fade_in()
	yield(Backdrop.get_node("AnimationPlayer"), "animation_finished")
	get_tree().paused = true
	emit_signal("game_ended")
	$BGMumble.stop()


func bossfight_music_start() -> void:
	_connect_signal("_on_music_selected", get_node("YSort/Player/HUD"), "_on_music_started")
	play_music()


func play_music() -> void:
	var returned_value = _get_random_sound(Lists.bossroom_music)
	curr_track = returned_value
	
	music_player.set_stream(Lists.bossroom_music[curr_track].track)
	music_player._set_playing(true)
	
	emit_signal("_on_music_selected", Lists.bossroom_music[curr_track].author + " - " + Lists.bossroom_music[curr_track].title)


func _get_random_sound(sound_type: Dictionary) -> int:
	rng.randomize()
	return rng.randi_range(0, sound_type.size() - 1)


func _on_Music_finished() -> void:
	if boss_alive == true:
		play_music()


func _start_phrases_spawn() -> void:
	if phrase_generator_enabled == true:
		var phrase_id = _get_ranom_phrase()
		var phrase_text
		var phrase_position
		phrase_position = _get_phrase_location()
		_generate_phrase(phrase_position, Lists.amulet_phrases[phrase_id])
		phrase_timer.start()


func _get_ranom_phrase() -> int:
	rng.randomize()
	return rng.randi_range(0, Lists.amulet_phrases.size() - 1)


func _get_phrase_location() -> Vector2:
	var x_position_limit = phrases_container.get_size().x
	var y_position_limit = phrases_container.get_size().y

	rng.randomize()

	var x_coord: int = rng.randi_range(0, x_position_limit - 80)
	var y_coord: int = rng.randi_range(0, y_position_limit - 20)

	var location: Vector2 = Vector2(x_coord, y_coord)
	return location


func _generate_phrase(phrase_position: Vector2, phrase_text: String):
	var phrase_item_instance = phrase_item_package.instance()
	
	_connect_signal("_init_phrase", phrase_item_instance, "_on_phrase_initiated")
	emit_signal("_init_phrase", phrase_text)
	disconnect("_init_phrase", phrase_item_instance, "_on_phrase_initiated")
	
	phrase_item_instance.set_global_position(phrase_position)
	phrases_container.add_child(phrase_item_instance)


func _on_Timer_timeout() -> void:
	if phrase_generator_enabled == true:
		_start_phrases_spawn()


func _on_MusicSoundTweakTween_tween_all_completed():
	music_player.autoplay = false
	music_player.playing = false


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
