extends HBoxContainer

var param_id: int

onready var sheet: Control = get_node("../../../../../../")

signal send_item_id(id)
signal clear_item_id

func _ready() -> void:
	_connect_signal("send_item_id", sheet, "_on_param_id_received")
	_connect_signal("clear_item_id", sheet, "_on_item_id_cleared")



func init(title: String, value: String, id: int) -> void:
	get_node("ParamTitle").text = title
	get_node("ParamValue").text = value
	param_id = id


func _on_ParamItem_mouse_entered() -> void:
	emit_signal("send_item_id", param_id)


func _on_ParamItem_mouse_exited() -> void:
	emit_signal("clear_item_id")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)

