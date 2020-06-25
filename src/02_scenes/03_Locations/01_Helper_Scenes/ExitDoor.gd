extends Node2D

var gate_opened: bool = false
var _message: String

onready var dungeon_lvl: Node2D = get_parent()
onready var sprite: AnimatedSprite = $Sprite

signal endgame_message_sent(msg)
signal _message_sent(msg, type)
signal _message_removed


func _ready() -> void:
	sprite.play("closed")


func _on_gate_opened() -> void:
	sprite.play("opening")
	gate_opened = true
	yield(get_tree().create_timer(0.6), "timeout")
	_load_next_lvl()


func _load_next_lvl() -> void:
	var next_lvl = Global.current_lvl + 1
	if next_lvl > 3:
		_message = Lists.level_messages["demo_end"]
		_connect_signal("endgame_message_sent", LvlSummary, "_end_demo_reached")
		Backdrop.fade_in()
		yield(Backdrop.get_node("AnimationPlayer"), "animation_finished")
		emit_signal("endgame_message_sent", _message)
	else:
		Backdrop.fade_in()
		yield(Backdrop.get_node("AnimationPlayer"), "animation_finished")
		var _change_msg = get_tree().reload_current_scene()
		Global.current_lvl += 1


func _on_MessageTrigger_body_entered(body) -> void:
	if body.name == 'Player':
		_connect_signal("_message_sent", body, "_on_message_received")
		_connect_signal("_message_removed", body, "_on_message_removed")
		body.can_open = true
		match body.loot_management.has_key:
			true:
				emit_signal("_message_sent", Lists.level_messages["have_key"], 2)
			false:
				if gate_opened == false:
					emit_signal("_message_sent", Lists.level_messages["no_key"], 1)


func _on_MessageTrigger_body_exited(body) -> void:
	if body.name == 'Player':
		body.can_open = false
		emit_signal("_message_removed")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)

