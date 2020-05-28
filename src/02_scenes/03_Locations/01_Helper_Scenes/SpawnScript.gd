extends Area2D

export var opening_direction: int
var spawned: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
onready var rooms: Node2D = get_node("/root/Dungeon/Rooms")


func _ready() -> void:
	_spawn()


func _spawn() -> void:
	if spawned == false:
		yield(get_tree().create_timer(0.2), "timeout")
		if opening_direction == 1 : # spawn top room with bottom door
				var room_type = "BOTTOM_ROOMS"
				var room_index: int = _get_random_room(room_type)
				var room_instance: TileMap = Lists.rooms[room_type].get(room_index).instance()
				room_instance.set_global_position(get_global_position())
				rooms.add_child(room_instance)
		elif opening_direction == 2: # spawn bottom room with top door
				var room_type = "TOP_ROOMS"
				var room_index: int = _get_random_room(room_type)
				var room_instance: TileMap = Lists.rooms[room_type].get(room_index).instance()
				room_instance.set_global_position(get_global_position())
				rooms.add_child(room_instance)
		elif opening_direction == 3: # spawn left room with right door
				var room_type = "RIGHT_ROOMS"
				var room_index: int = _get_random_room(room_type)
				var room_instance: TileMap = Lists.rooms[room_type].get(room_index).instance()
				room_instance.set_global_position(get_global_position())
				rooms.add_child(room_instance)
		elif opening_direction == 4: # spawn rigth room with left door
				var room_type = "LEFT_ROOMS"
				var room_index: int = _get_random_room(room_type)
				var room_instance: TileMap = Lists.rooms[room_type].get(room_index).instance()
				room_instance.set_global_position(get_global_position())
				rooms.add_child(room_instance)
		spawned = true


func _get_random_room(toom_type: String) -> int:
	rng.randomize()
	return rng.randi_range(1, Lists.rooms[toom_type].size())


func _on_SpawnPoint_area_entered(area: Area2D) -> void:
	if area.name == "RoomSpawnPoint":
		print(area.get_parent().get_parent().name)
		spawned = true
		queue_free()
