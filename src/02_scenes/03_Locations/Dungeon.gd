extends Node2D

enum TILE_TYPE {Empty = -1, Filled = 0}

const MAP_WIDTH: int = 80
const MAP_HEIGHT: int = 80
const MIN_ROOM_SIZE: int = 12
const MAX_ROOM_SIZE: int = 17

var Room: GDScript = preload("res://src/02_scenes/03_Locations/01_Room/Room.gd")

var _rooms: Array = []
var _map: Array = []

var rng = RandomNumberGenerator.new()

onready var _tile_map: TileMap = $TileMap



func _ready() -> void:
	_generate_map()


func _generate_map() -> void:
	_map = _create_2d_arr()
	
	rng.randomize()
	var _room_width: int = rng.randi_range(MIN_ROOM_SIZE, MAX_ROOM_SIZE)
	var _room_height: int = rng.randi_range(MIN_ROOM_SIZE, MAX_ROOM_SIZE)
	
	for x in _room_width:
		for y in _room_height:
			_map[x][y] = TILE_TYPE.Filled

	for x in MAP_WIDTH:
		for y in MAP_HEIGHT:
			_tile_map.set_cell(x, y, _map[x][y])

	_tile_map.update_bitmask_region()


func _create_2d_arr() -> Array:
	var _map_array: Array = []
	
	for x in MAP_WIDTH:
		_map_array.append([])
		
		for y in MAP_HEIGHT:
			_map_array[x].append(TILE_TYPE.Empty)
	
	return _map_array


func _input(event) -> void:
	if event.is_action_pressed("ui_accept"):
		_tile_map.clear()
		_generate_map()
