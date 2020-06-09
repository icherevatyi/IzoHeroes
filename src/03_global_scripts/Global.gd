extends Node

var menu: PackedScene = preload("res://src/02_scenes/01_UI/03_Menus/Menu.tscn")

var cursor_passive = load("res://src/01_assets/01_UI/cursor_passive.png")
var cursor_active = load("res://src/01_assets/01_UI/cursor_active.png")
var current_lvl: int = 1

var _scene_change_value
var is_game_started: bool = false
var is_paused: bool = false


func _ready() -> void:
	set_pause_mode(2)
	Input.set_custom_mouse_cursor(cursor_passive, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(cursor_active, Input.CURSOR_POINTING_HAND)


func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()


func call_main_menu() -> void:
	_scene_change_value = get_tree().change_scene_to(menu)


func toggle_pause_menu() -> void:
	get_tree().paused = !get_tree().paused
	if is_game_started == true:
			var dungeon = get_parent().get_node("Dungeon")
			var menu_instance = menu.instance()
			match is_paused:
				false:
					dungeon.add_child(menu_instance)
					is_paused = true
				true:
					if dungeon.has_node("Menu"):
						dungeon.get_node("Menu").queue_free()
					is_paused = false


func start_game() -> void:
	ResourceStorage.player_data =  ResourceStorage.player_original_data
	is_game_started = true
	is_paused = false
	get_tree().paused = false
	_scene_change_value = get_tree().change_scene("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/Dungeon.tscn")


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


func set_cursor_active() -> void:
	Input.set_custom_mouse_cursor(cursor_active)


func set_cursor_passive() -> void:
	Input.set_custom_mouse_cursor(cursor_passive)
