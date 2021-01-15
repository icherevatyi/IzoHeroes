extends TileMap

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var dungeon: Node2D = get_node("/root/Dungeon")
onready var exit_spawner_position: Position2D = $ExitSpawner
onready var sleeping_bag_position: Position2D = $SleepingBagSpawner

signal _send_exit_door_coords(coords)
signal _send_sleeping_bag_coords(coords)

func _ready():
	_connect_signal("_send_exit_door_coords", dungeon, "_on_exit_position_received")
	_connect_signal("_send_sleeping_bag_coords", dungeon, "_on_sleeping_bag_position_received")


func _on_create_exit_command_received() -> void:
	emit_signal("_send_exit_door_coords", exit_spawner_position.get_global_position())


func _on_create_sleeping_bag_command_received() -> void:
	emit_signal("_send_sleeping_bag_coords", sleeping_bag_position.get_global_position())


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
