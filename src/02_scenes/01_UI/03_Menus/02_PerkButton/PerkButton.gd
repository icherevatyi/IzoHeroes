extends Control

var index: int

onready var btn_text: Label = $BtnText
onready var btn_texture: TextureButton = $Texture

signal return_type(index)
signal clear_type

func item_init(perk_title, perk_index) -> void:
	_connect_signal("return_type", LvlSummary, "_on_perk_type_received")
	_connect_signal("clear_type", LvlSummary, "_on_perk_type_cleared")
	btn_text.set_text(perk_title)
	index = perk_index


func _on_Button_mouse_entered():
	emit_signal("return_type", index)


func _on_Button_mouse_exited():
	emit_signal("clear_type")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)


