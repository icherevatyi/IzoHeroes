extends TileMap

var exit_door: PackedScene = preload("res://src/02_scenes/03_Locations/01_Helper_Scenes/ExitDoor.tscn")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
onready var dungeon: Node2D = get_node("/root/Dungeon")



func _on_create_exit_command_received() -> void:
	_create_exit(_select_random_wall_tile())


func _select_random_wall_tile() -> Vector2:
	var possible_placement_options = get_used_cells_by_id(02)
	var viable_placement_options = possible_placement_options.slice(1, possible_placement_options.size() - 2)
	rng.randomize()
	var placement = rng.randi_range(0, viable_placement_options.size() - 1)
	return viable_placement_options[placement]


func _create_exit(placement_position: Vector2) -> void:
	var exit_instance: Node2D = exit_door.instance()
	exit_instance.set_global_position(placement_position * Vector2(16, 16))
	add_child(exit_instance)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
