extends Area2D

export var opening_direction: int

var room_types: Dictionary = {
	1: "BOTTOM",
	2: "TOP",
	3: "RIGHT",
	4: "LEFT"
}

var spawned: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var closed_room_sum: int = 0
var closed_room_sequence: String

onready var closed_room_timer: Timer = $ClosedRoomTimer
onready var rooms: Node2D = get_node("/root/Dungeon/Rooms")


func _ready() -> void:
	add_to_group("SPAWN_POINT")


func _spawn() -> void:
	if spawned == false:
		if opening_direction == 1 : # spawn top room with bottom door
			var room_type = room_types[1]
			var room_index: int = _get_random_room(room_type)
			var room_instance: TileMap = Lists.rooms[room_type].get(room_index).instance()
			room_instance.set_global_position(get_global_position())
			rooms.add_child(room_instance)
		elif opening_direction == 2: # spawn bottom room with top door
			var room_type = room_types[2]
			var room_index: int = _get_random_room(room_type)
			var room_instance: TileMap = Lists.rooms[room_type].get(room_index).instance()
			room_instance.set_global_position(get_global_position())
			rooms.add_child(room_instance)
		elif opening_direction == 3: # spawn left room with right door
			var room_type = room_types[3]
			var room_index: int = _get_random_room(room_type)
			var room_instance: TileMap = Lists.rooms[room_type].get(room_index).instance()
			room_instance.set_global_position(get_global_position())
			rooms.add_child(room_instance)
		elif opening_direction == 4: # spawn rigth room with left door
			var room_type = room_types[4]
			var room_index: int = _get_random_room(room_type)
			var room_instance: TileMap = Lists.rooms[room_type].get(room_index).instance()
			room_instance.set_global_position(get_global_position())
			rooms.add_child(room_instance)
		spawned = true


func _get_random_room(toom_type: String) -> int:
	rng.randomize()
	return rng.randi_range(1, Lists.rooms[toom_type].size())


func _on_SpawnPoint_area_entered(area: Area2D) -> void:
	if area.is_in_group("SPAWN_POINT"):
		if area.spawned == false and spawned == false:
			closed_room_sum = opening_direction + area.opening_direction
			if closed_room_sum != 0:
				closed_room_sequence = room_types[area.opening_direction] + "_" + room_types[opening_direction]
				closed_room_timer.start()
		spawned = true


func _on_Timer_timeout():
	_spawn()


func _on_ClosedRoomTimer_timeout():
	var room_instance: TileMap = Lists.closing_rooms[closed_room_sequence].instance()
	room_instance.set_global_position(get_global_position())
	rooms.add_child(room_instance)
	queue_free()
