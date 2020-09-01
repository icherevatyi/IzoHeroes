extends RigidBody2D

var is_flipped: bool = false

signal do_damage(damage)

func _ready() -> void:
	print(is_flipped)
	apply_impulse(Vector2(), Vector2(150, 0).rotated(rotation))
	match is_flipped:
		false:
			$Sprite.flip_v = false
		true:
			$Sprite.flip_v = true
	


func _on_MagicSkull_body_entered(body) -> void:
	print(body.name)
	if body.name == "Player":
		_connect_signal("do_damage", body, "_damage_taken")
		emit_signal("do_damage", 1)
		disconnect("do_damage", body, "_damage_taken")
		queue_free()
	if body.is_in_group("rooms"):
		queue_free()


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)

