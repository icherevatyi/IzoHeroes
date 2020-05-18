extends "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/01_DungeonStart/StartRoom.gd"


func _ready() -> void:
	available_corridors.left.available = true
	available_corridors.right.available = true
