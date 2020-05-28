extends "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/Room.gd"


func _ready():
	available_corridors.left.available = true
	available_corridors.right.available = true
