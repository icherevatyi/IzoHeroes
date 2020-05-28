extends Node2D

var min_rooms_count: int = 4
var max_rooms_count: int = 6
var rooms_count: int
var rng = RandomNumberGenerator.new()

onready var room_container: Node2D = $Rooms

signal _get_room_corridors(entrance)


func _ready() -> void:
	Backdrop.fade_out()
	_create_starting_room()
	_calculate_rooms_count()


func _calculate_rooms_count() -> void:
	rng.randomize()
	rooms_count = rng.randi_range(min_rooms_count, max_rooms_count)


func _create_starting_room() -> void:
	var room_instance: TileMap =  _get_room_index("START").instance()
	_connect_signal("_get_room_corridors", room_instance, "_on_corridors_asked")
	room_instance.set_global_position(Vector2(0, 0))
	room_container.add_child(room_instance)
	call_deferred("emit_signal", "_get_room_corridors", null)


func _get_room_index(type: String) -> PackedScene:
	rng.randomize()
	var first_room = 1
	var last_room = Lists.rooms_list[type].size()
	var final_room = rng.randi_range(first_room, last_room)
	return Lists.rooms_list[type].get(final_room)


func _on_corridors_received(opened_corridors) -> void:
	print(opened_corridors)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
