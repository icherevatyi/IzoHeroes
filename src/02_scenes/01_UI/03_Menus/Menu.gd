extends CanvasLayer

var _funcion_response: int
var menu_item: PackedScene = preload("res://src/02_scenes/01_UI/03_Menus/01_MenuItem/MenuItem.tscn")
var is_press_action_enabled: bool = false

onready var menu_container: TextureRect = $MenuBg 
onready var background: ColorRect = $Background
onready var main_menu_bg: Control = $MainMenuImageBG
onready var items_container: VBoxContainer = $MenuBg/ItemsContainer
onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
onready var audio_tween: Tween = $AudioTween
onready var plot_screen: VBoxContainer = $ProtScreen

signal _on_music_started(author)


func _ready() -> void:
	var _signal_responce := connect("_on_music_started", $MusicAuthorNotifier, "_on_author_name_received")
	set_pause_mode(2)
	if Global.is_game_started == false:
		_start_main_menu()
	if Global.is_game_started == true:
		match Global.is_player_dead:
			false:
				background.color = Color(0, 0, 0, 0.6)
				_start_pause_menu()
			true:
				background.color = Color(0, 0, 0, 0.6)
				_start_deathscreen_menu()


func _input(event):
	if event.is_action_pressed("spacebar"):
		match is_press_action_enabled:
			true:
				_on_PressToContinue_pressed()
			false:
				return


func _start_main_menu() -> void:
	background.color = Color(0, 0, 0, 1)
	main_menu_bg.visible = true
	_start_music()
	emit_signal("_on_music_started", 'plasterbrain - "(Fantasy Loop) Mystical Journey"')
	for item_index in Lists.main_menu_list:
		var item_instance: TextureButton = menu_item.instance()
		var item_title: String = Lists.main_menu_list[item_index].title
		var item_action = Lists.main_menu_list[item_index].action
		
		items_container.add_child(item_instance)
		item_instance.item_init(item_title, item_action)


func _show_plot() -> void:
	plot_screen.visible = true
	is_press_action_enabled = true
	menu_container.visible = false


func _on_PressToContinue_pressed() ->  void:
	Global.start_game()


func _start_music() -> void:
	audio_player.playing = true
	_funcion_response = audio_tween.interpolate_property(audio_player, "volume_db", -80, 0, 1, Tween.EASE_IN, Tween.TRANS_LINEAR)
	_funcion_response = audio_tween.start()
	


func _start_deathscreen_menu() -> void:
	for item_index in Lists.deathscreen_game_list:
		var item_instance: TextureButton = menu_item.instance()
		var item_title: String = Lists.deathscreen_game_list[item_index].title
		var item_action = Lists.deathscreen_game_list[item_index].action
		
		items_container.add_child(item_instance)
		item_instance.item_init(item_title, item_action)


func _start_pause_menu() ->  void:
	main_menu_bg.visible = false
	for item_index in Lists.pause_game_list:
		var item_instance: TextureButton = menu_item.instance()
		var item_title: String = Lists.pause_game_list[item_index].title
		var item_action = Lists.pause_game_list[item_index].action
		
		items_container.add_child(item_instance)
		item_instance.item_init(item_title, item_action)
