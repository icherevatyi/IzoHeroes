extends Node2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var room_container: Node2D = $Rooms

signal _create_exit


func _ready() -> void:
	Backdrop.fade_out()


func _select_random_room() -> void:
	var rooms = room_container.get_children()
	var selected_child
	if rooms.size() > 4:
		rng.randomize()
		selected_child = rng.randi_range(3, rooms.size() - 1)
	else:
		rng.randomize()
		selected_child = rooms.size()
	_connect_signal("_create_exit", rooms[selected_child], "_on_create_exit_command_received")


func _on_CreateExitTimer_timeout():
	_select_random_room()
	emit_signal("_create_exit")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
