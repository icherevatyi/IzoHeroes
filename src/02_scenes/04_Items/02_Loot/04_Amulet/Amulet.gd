extends StaticBody2D


onready var float_animation_handler: AnimationPlayer = $FloatAnimator
onready var sprite: Sprite = $Sprite
onready var item_drop_sound_player: AudioStreamPlayer = $ItemDropAudio

signal amulet_picked_up


func _ready() -> void:
	_connect_signal("amulet_picked_up", get_node("/root/Dungeon"), "_on_amulet_pickup")
	_sound_item_drop()
	_start_floating()


func _sound_item_drop() -> void:
	item_drop_sound_player._set_playing(true)


func _start_floating() -> void:
	float_animation_handler.play("float")


func _on_item_picked_up() -> void:
	emit_signal("amulet_picked_up")
	queue_free()


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
