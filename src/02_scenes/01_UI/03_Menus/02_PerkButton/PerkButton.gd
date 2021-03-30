extends TextureButton

var index: int

var perk_hover: Resource = load("res://src/01_assets/09_Audio/s_ui/menu_hover.ogg")
var perk_m_pressed: Resource = load("res://src/01_assets/09_Audio/s_ui/menu_m_pressed.ogg")
var perk_m_released: Resource = load("res://src/01_assets/09_Audio/s_ui/menu_m_released.ogg")

onready var glyph: TextureRect = $Glyph
onready var perk_audio: AudioStreamPlayer = $AudioStreamPlayer

signal return_type(index)
signal clear_type

func item_init(perk_icon, perk_index) -> void:
	_connect_signal("return_type", LvlSummary, "_on_perk_type_received")
	_connect_signal("clear_type", LvlSummary, "_on_perk_type_cleared")
	get_node("Glyph").set_texture(perk_icon)
	index = perk_index


func _on_Texture_mouse_entered() -> void:
	perk_audio.set_stream(perk_hover)
	perk_audio._set_playing(true)
	emit_signal("return_type", index)


func _on_Texture_mouse_exited() -> void:
	emit_signal("clear_type")


func _on_Texture_button_down() -> void:
	glyph._set_position(Vector2(27.5, 3.5))
	perk_audio.set_stream(perk_m_pressed)
	perk_audio._set_playing(true)


func _on_Texture_button_up() -> void:
	glyph._set_position(Vector2(27.5, 1.5))
	perk_audio.set_stream(perk_m_released)
	perk_audio._set_playing(true)


func _on_AudioStreamPlayer_finished() -> void:
	if perk_audio.get_stream() == perk_m_released:
		PlayerStats.update_stat(index)
		LvlSummary._on_lvl_proceed()


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
