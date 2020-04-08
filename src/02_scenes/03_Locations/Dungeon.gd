extends Node2D


var size_x: int
var size_y: int

onready var _tilemap_node: TileMap = $TileMap


func _ready() -> void:
	_generate_tile()


func _randomize_tile_size() -> void:
	randomize()
	size_x = randi() % 15 + 8 
	size_y = randi() % 15 + 8

func _generate_tile() -> void:
	_randomize_tile_size()
	
	for element_x in size_x:
		for element_y in size_y:
			_tilemap_node.set_cell(element_x, element_y, 0)
	_tilemap_node.update_bitmask_region()
