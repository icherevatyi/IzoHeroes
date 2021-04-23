extends CanvasLayer


onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var color_box: ColorRect = $ColorRect


func fade_in(speed = 1) -> void:
	animation_player.playback_speed = speed
	animation_player.play("fade_in")


func fade_out() -> void:
	animation_player.play_backwards("fade_in")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
