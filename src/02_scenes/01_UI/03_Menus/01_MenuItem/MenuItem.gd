extends TextureButton

var button_action: String
var _func_response_value

onready var btn_text: Label = $BtnText

func item_init(title, action) -> void:
	btn_text.set_text(title)
	button_action = action


func _on_MenuItem_pressed() -> void:
	btn_text._set_position(Vector2(-1, 5.5))
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


func _on_MenuItem_button_down():
	btn_text._set_position(Vector2(-1, 5.5))


func _on_MenuItem_button_up():
	btn_text._set_position(Vector2(-1, 3.5))
