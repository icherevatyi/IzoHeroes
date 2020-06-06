extends Node2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var room_container: Node2D = $Rooms

signal _create_exit


func _ready() -> void:
	Backdrop.fade_out()
	yield(get_tree().create_timer(2),"timeout")
	_select_random_room()
	emit_signal("_create_exit")


func _select_random_room() -> void:
	var rooms = room_container.get_children()
	var selected_child
	rng.randomize()
	if rooms.size() > 4:
		selected_child = rng.randi_range(3, rooms.size() - 1)
	else:
		selected_child = rooms.size()
	_connect_signal("_create_exit", rooms[selected_child], "_on_create_exit_command_received")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
