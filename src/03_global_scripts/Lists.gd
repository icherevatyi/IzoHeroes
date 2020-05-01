extends Node


var main_menu_list: Dictionary = {
	1: {
		"title": "New Game",
		"action": "START_GAME"
	},
	2: {
		"title": "Continue Game",
		"action": "LOAD_GAME"
	},
	3: {
		"title": "Options",
		"action": "SHOW_OPTIONS"
	},
	4: {
		"title": "Exit to Desktop",
		"action": "QTD"
	},
}


var pause_game_list: Dictionary = {
	1: {
		"title": "Return to Game",
		"action": "RETURN_TO_GAME"
	},
	2: {
		"title": "Load from Checkpoint",
		"action": "LOAD_GAME"
	},
	3: {
		"title": "Options",
		"action": "SHOW_OPTIONS"
	},
	4: {
		"title": "Exit to Main Menu",
		"action": "QTM"
	},
	5: {
		"title": "Exit to Desktop",
		"action": "QTD"
	},
}


var options_list: Dictionary = {
	
}


var lvl_list: Dictionary = {
	1: "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/01/Dungeon_1.tscn",
	2: "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02/Dungeon_2.tscn",
	3: "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/03/Dungeon_3.tscn",
	4: "res://src/02_scenes/03_Locations/02_Dungeon_Scenes/04/Dungeon_4.tscn",
}


var enemy_list: Dictionary = {
	1: {
		"scene": preload("res://src/02_scenes/02_Characters/02_Enemies/02_Skeleton/Skeleton.tscn"),
		"type": "Skeleton",
		"health_max": 100,
		"damage": 1
	}
}
