extends Node2D

var gate_opened: bool = false
var _message: String = "You reached end of this demo, thank you for playing!"

onready var dungeon_lvl: Node2D = get_parent()
onready var sprite: AnimatedSprite = $Sprite

signal endgame_message_sent(msg)
signal collect_player_data


func _ready() -> void:
	sprite.play("closed")


func _on_gate_opened() -> void:
	sprite.play("opening")
	gate_opened = true


func _load_next_lvl() -> void:
	var next_lvl = Global.current_lvl + 1
	if next_lvl > 3:
		_connect_signal("endgame_message_sent", LvlSummary, "_end_demo_reached")
		Backdrop.fade_in()
		yield(Backdrop.get_node("AnimationPlayer"), "animation_finished")
		emit_signal("endgame_message_sent", _message)
	else:
		Backdrop.fade_in()
		yield(Backdrop.get_node("AnimationPlayer"), "animation_finished")
		var _change_msg = get_tree().reload_current_scene()
		Global.current_lvl += 1


func _on_ExitTrigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("gate opened: ", gate_opened)
		if gate_opened == true:
			_connect_signal("collect_player_data", body, "_on_data_request_received")
			emit_signal("collect_player_data")
		
			_load_next_lvl()


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)


func _on_Sprite_animation_finished():
	pass # Replace with function body.
