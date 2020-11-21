extends Node2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var exit_door: PackedScene = preload("res://src/02_scenes/03_Locations/01_Helper_Scenes/ExitDoor.tscn")

onready var room_container: Node2D = $Rooms
onready var characters_container: YSort = $YSort

signal _create_exit
signal _add_miniboss

func _ready() -> void:
	Backdrop.fade_out()


func _select_random_room() -> void:
	var _rooms: Array
	var selected_child
	for room in room_container.get_children():
		if room.is_in_group("has_exit"):
			_rooms.append(room)
	if _rooms.size() > 4:
		rng.randomize()
		selected_child = rng.randi_range(3, _rooms.size() - 1)
	else:
		rng.randomize()
		selected_child = rng.randi_range(0, _rooms.size() - 1)
	_connect_signal("_create_exit", _rooms[selected_child], "_on_create_exit_command_received")


func _on_exit_position_received(position_coords: Vector2) -> void:
	var exit_instance: Node2D = exit_door.instance()
	exit_instance.set_global_position(position_coords)
	room_container.add_child(exit_instance)
	print("Spawned door expected position: ", position_coords)


func _select_random_enemy() -> int:
	var all_characters: Array = characters_container.get_children()
	rng.randomize()
	return rng.randi_range(0, all_characters.size() - 2)


func _evolve_to_miniboss() -> void:
	var all_characters: Array = characters_container.get_children()
	for character in all_characters:
		if not character.is_in_group("Enemies"):
			all_characters.erase(character)
	var _selected_enemy = all_characters[_select_random_enemy()]
	_connect_signal("_add_miniboss", _selected_enemy, "_on_miniboss_created")
	emit_signal("_add_miniboss")


func _on_CreateExitTimer_timeout():
	_select_random_room()
	_evolve_to_miniboss()
	emit_signal("_create_exit")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
