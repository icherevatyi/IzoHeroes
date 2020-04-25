extends Node

var lvl_list: Dictionary = {
	1: "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/01/Dungeon_1.tscn",
	2: "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02/Dungeon_2.tscn",
	3: "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/03/Dungeon_3.tscn",
	4: "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/04/Dungeon_4.tscn",
}


var enemy_list: Dictionary = {
	1: {
		"scene": preload("res://src/02_scenes/02_Characters/02_Enemies/01_Skeleton/Skeleton.tscn"),
		"type": "Skeleton",
		"health_max": 100,
		"damage": 1
	}
}
