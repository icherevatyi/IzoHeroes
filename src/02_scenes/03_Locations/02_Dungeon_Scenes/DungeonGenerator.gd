extends Node2D

var entrance: PackedScene = preload("res://src/02_scenes/03_Locations/01_Helper_Scenes/Entrance.tscn")
var max_tile_size: int = 30
var lvl_rect: Vector2 = Vector2(max_tile_size, max_tile_size)
var digger_position: Vector2 = Vector2(8, 8)
var tile_step: Vector2 = Vector2(3, 3)

var rng = RandomNumberGenerator.new()

onready var map: TileMap = $TileMap


func _ready() -> void:
	Backdrop.fade_out()
	
	create_digger()
	_add_entrance()


func create_digger() -> void:	
	for x in range(digger_position.x - 2, digger_position.x + 2):
		for y in range(digger_position.y - 2, digger_position.y + 2):
			map.set_cell(x, y, 0)
	map.update_bitmask_region()
	
	start_digging()


func select_dig_direction(prev_direction) -> int:
	rng.randomize()
	var direction = rng.randi_range(0, 3)
	if direction == prev_direction:
		direction = rng.randi_range(0, 3)
	return direction


func start_digging() -> void:	
	for x in range(digger_position.x - 3, digger_position.x + 4):
		for y in range(digger_position.y -6, digger_position.y + 3):
			map.set_cell(x, y, 0)
	map.update_bitmask_region()


func _add_entrance() -> void:
	var creation_y_point = (digger_position.y + 2) * 16
	var entrance_position = Vector2(digger_position.x * 16, creation_y_point)
	var entrance_instance = entrance.instance()
	entrance_instance.set_global_position(entrance_position)
	self.add_child_below_node(map, entrance_instance)


func dig_dungeon() -> void:
	var dig_steps = 100
	for step in range(dig_steps):
		match select_dig_direction(0):
			0:
				digger_position.y -= 3
			1:
				digger_position.y += 3
			2:
				digger_position.x += 3
			3:
				digger_position.x -= 3
		dig_steps -= 1
		
		for x in range(digger_position.x - 2, digger_position.x +2):
			for y in range(digger_position.y - 2, digger_position.y + 2):
				map.set_cell(x, y, 0)
		map.update_bitmask_region()
