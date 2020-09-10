extends Node

var menu: PackedScene = preload("res://src/02_scenes/01_UI/03_Menus/Menu.tscn")
var console: PackedScene = preload("res://src/02_scenes/01_UI/04_Console/Console.tscn")

var cursor = load("res://src/01_assets/01_UI/cursor.png")
var current_lvl: int = 1
var hp_modifier: float

var _scene_change_value
var is_game_started: bool = false
var is_paused: bool = false
var is_player_dead: bool = false
var is_console_enabled: bool = false
var is_menu_enabled: bool = false

onready var root_node = get_node("/root/")


func _ready() -> void:
	set_pause_mode(2)
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_POINTING_HAND)
	_check_modifier_active()


func _check_modifier_active() -> void:
	if current_lvl == 1:
		hp_modifier = 1
	else:
		hp_modifier *= 1.3


func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_player_dead == false:
			toggle_pause_menu()
	if event.is_action_pressed("console"):
		toggle_console()
		if is_menu_enabled == false:
			get_tree().paused = !get_tree().paused


func toggle_console() -> void:
	is_console_enabled = !is_console_enabled
	if root_node.has_node("Console"):
		root_node.remove_child(get_node("/root/Console"))
	else:
		root_node.add_child(console.instance())


func call_main_menu() -> void:
	_scene_change_value = get_tree().change_scene_to(menu)


func toggle_pause_menu() -> void:
	if is_game_started == true:
		is_menu_enabled = !is_menu_enabled
		var dungeon = get_parent().get_node("Dungeon")
		var menu_instance = menu.instance()
		
		if dungeon.has_node("Menu"):
			dungeon.remove_child(get_node("/root/Dungeon/Menu"))
		else:
			dungeon.add_child(menu_instance)
		
		if is_console_enabled == false:
			get_tree().paused = !get_tree().paused



func start_game() -> void:
	ResourceStorage.player_data =  ResourceStorage.player_original_data
	_reset_params()
	is_game_started = true
	is_paused = false
	get_tree().paused = false
	_scene_change_value = get_tree().change_scene("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/Dungeon.tscn")


func _reset_params() -> void:
	for param in PlayerStats.perk_list:
		PlayerStats.perk_list[param].perk_lvl = 0
	for param in PlayerStats.stats_list:
		PlayerStats.stats_list[param].value = PlayerStats.stats_list[param].base_value


func load_game() -> void:
	is_game_started = true
	is_paused = false
	get_tree().paused = false
	SaveLoad.load_game()
	_scene_change_value = get_tree().change_scene("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/Dungeon.tscn")


func exit_to_menu() -> void:
	is_game_started = false
	is_paused = false
	get_tree().paused = false
	SaveLoad.save_game()
	_scene_change_value = get_tree().change_scene("res://src/02_scenes/01_UI/03_Menus/Menu.tscn")
	

func exit_game() -> void:
	SaveLoad.save_game()
	get_tree().quit()
