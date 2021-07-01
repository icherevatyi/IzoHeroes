extends TextureButton

var button_action: String
var _func_response_value

var menu_hover: Resource = load("res://src/01_assets/09_Audio/s_ui/menu_hover.ogg")
var menu_m_pressed: Resource = load("res://src/01_assets/09_Audio/s_ui/menu_m_pressed.ogg")
var menu_m_released: Resource = load("res://src/01_assets/09_Audio/s_ui/menu_m_released.ogg")

onready var btn_text: Label = $BtnText
onready var menu_audio: AudioStreamPlayer = $AudioStreamPlayer


func item_init(title, action) -> void:
	btn_text.set_text(title)
	button_action = action


func _on_MenuItem_mouse_entered():
	menu_audio.set_stream(menu_hover)
	menu_audio._set_playing(true)


func _on_MenuItem_pressed() -> void:
	btn_text._set_position(Vector2(-1, 5.5))


func _on_MenuItem_button_down():
	menu_audio.set_stream(menu_m_pressed)
	menu_audio._set_playing(true)
	btn_text._set_position(Vector2(-1, 5.5))


func _on_MenuItem_button_up():
	menu_audio.set_stream(menu_m_released)
	menu_audio._set_playing(true)
	btn_text._set_position(Vector2(-1, 3.5))



func _on_AudioStreamPlayer_finished():
	if menu_audio.get_stream() == menu_m_released:
		match button_action:
			"START_GAME":
				get_parent().get_owner()._show_plot()
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
