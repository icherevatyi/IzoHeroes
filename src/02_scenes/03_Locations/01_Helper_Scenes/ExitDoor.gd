extends Node2D

var lvl_list: Dictionary = Lists.lvl_list
var _message: String = "You reached end of this demo, thank you for playing!"

onready var dungeon_lvl: Node2D = get_parent()

signal message_sent(msg)


func _get_current_lvl() -> int:
	var _current_lvl: String = get_parent().filename
	for lvl in lvl_list:
		if lvl_list[lvl] == _current_lvl:
			return int(lvl)
	return 0


func _load_next_lvl(player) -> void:
	var next_lvl = _get_current_lvl() + 1
	if int(lvl_list.size()) < next_lvl:
		_connect_signal("message_sent", player, "_on_message_received")
		emit_signal("message_sent", _message)
		
		# Here should be code to call a backdrop and load message instead of next lvl
	else:
		# Here should be code to call a backdrop and load next lvl
		Backdrop.fade_in()
		yield(Backdrop.get_node("AnimationPlayer"), "animation_finished")
		var _change_msg = get_tree().change_scene(lvl_list[next_lvl])


func _on_ExitTrigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_load_next_lvl(body)


func _connect_signal(signal_title: String, target_node: Node2D, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
