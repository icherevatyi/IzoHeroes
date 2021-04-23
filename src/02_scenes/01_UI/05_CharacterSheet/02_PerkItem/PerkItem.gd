extends Control

var perk_id: int

onready var sheet: Node2D = get_parent().get_owner()

signal send_item_id(id)
signal clear_item_id


func _ready() -> void:
	_connect_signal("send_item_id", sheet, "_on_perk_id_received")
	_connect_signal("clear_item_id", sheet, "_on_item_id_cleared")


func init(perk_lvl: int, perk_icon: Object, id: int) -> void:
	get_node("Texture/Glyph").set_texture(perk_icon)
	get_node("Texture/PerkLvl").set_text(str(perk_lvl))
	perk_id = id


func _on_PerkItem_mouse_entered() -> void:
	emit_signal("send_item_id", perk_id)


func _on_PerkItem_mouse_exited() -> void:
	emit_signal("clear_item_id")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)

