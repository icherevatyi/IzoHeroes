extends Button

var button_action: String
var _func_response_value


func item_init(title, action) -> void:
	set_text(title)
	button_action = action


func _on_MenuItem_pressed() -> void:
	match button_action:
		"START_GAME":
			Global.start_game()
		"LOAD_GAME":
			Global.load_game()
		"RETURN_TO_GAME":
			Global.toggle_pause_menu()
		"SHOW_OPTIONS":
			Global.call_main_menu()
		"QTM":
			Global.exit_to_menu()
		"QTD":
			Global.exit_game()
		"DUNGEON_GENERATOR":
			Global.show_map_generator()
