extends Node


var level_messages: Dictionary = {
	"entrance_closed": "Rusty gate closed behind you. It is tightly sealed and the only way to leave this place is to move forward.",
	"no_key": "You need a key, it should be carried by someone here.",
	"have_key": "Old key is laying in your pocket, picked from and ugly abomination of foul magic. Are you sure you want to open the gate lock?",
	"demo_end": "You reached end of this demo, thank you for playing!"
}


var main_menu_list: Dictionary = {
	1: {
		"title": "New Game",
		"action": "START_GAME"
	},
	2: {
		"title": "Continue",
		"action": "LOAD_GAME"
	},
	3: {
		"title": "Options",
		"action": "SHOW_OPTIONS"
	},
	4: {
		"title": "Exit to Desktop",
		"action": "QTD"
	}
}


var pause_game_list: Dictionary = {
	1: {
		"title": "Return to Game",
		"action": "RETURN_TO_GAME"
	},
	2: {
		"title": "Load Checkpoint",
		"action": "LOAD_GAME"
	},
	3: {
		"title": "Options",
		"action": "SHOW_OPTIONS"
	},
	4: {
		"title": "Exit to Menu",
		"action": "QTM"
	},
	5: {
		"title": "Exit to Desktop",
		"action": "QTD"
	},
}


var deathscreen_game_list: Dictionary = {
	1: {
		"title": "Load Checkpoint",
		"action": "LOAD_GAME"
	},
	2: {
		"title": "Options",
		"action": "SHOW_OPTIONS"
	},
	3: {
		"title": "Exit to Menu",
		"action": "QTM"
	},
	4: {
		"title": "Exit to Desktop",
		"action": "QTD"
	},
}


var options_list: Dictionary = {
	
}

var closing_rooms: Dictionary = {
	"BOTTOM_LEFT": preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/02_BL/Room1.tscn"),
	"BOTTOM_RIGHT": preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/03_BR/Room1.tscn"),
	"BOTTOM_TOP": preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/05_TB/Room1.tscn"),
	"TOP_LEFT": preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/06_TL/Room1.tscn"),
	"TOP_RIGHT": preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/06_TR/Room1.tscn"),
	"TOP_BOTTOM": preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/05_TB/Room1.tscn"),
	"LEFT_RIGHT": preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/09_LR/Room1.tscn"),
	"RIGHT_LEFT": preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/09_LR/Room1.tscn"),
}


var rooms: Dictionary = {
	"TOP": {
		1: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/04_T/Room1.tscn"),
		2: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/05_TB/Room1.tscn"),
		3: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/06_TL/Room1.tscn"),
		4: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/06_TR/Room1.tscn"),
		
		# Additional closing room to decrease dungeon size
		5: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/04_T/Room1.tscn"),
		6: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/04_T/Room1.tscn"),
	},
	"BOTTOM": {
		1: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/01_B/Room1.tscn"),
		2: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/05_TB/Room1.tscn"),
		3: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/02_BL/Room1.tscn"),
		4: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/03_BR/Room1.tscn"),
		
		# Additional closing room to decrease dungeon size
		5: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/01_B/Room1.tscn"),
		6: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/01_B/Room1.tscn"),
	},
	"LEFT": {
		1: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/08_L/Room1.tscn"),
		2: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/06_TL/Room1.tscn"),
		3: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/02_BL/Room1.tscn"),
		4: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/09_LR/Room1.tscn"),
		
		# Additional closing room to decrease dungeon size
		5: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/08_L/Room1.tscn"),
		6: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/08_L/Room1.tscn"),
	},
	"RIGHT": {
		1: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/10_R/Room1.tscn"),
		2: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/06_TR/Room1.tscn"),
		3: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/03_BR/Room1.tscn"),
		4: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/09_LR/Room1.tscn"),
		
		# Additional closing room to decrease dungeon size
		5: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/10_R/Room1.tscn"),
		6: preload("res://src/02_scenes/03_Locations/02_Dungeon_Scenes/02_Rooms/10_R/Room1.tscn"),
	},
}

var enemy_list: Dictionary = {
	1: {
		"scene": preload("res://src/02_scenes/02_Characters/02_Enemies/02_Skeleton/Skeleton.tscn"),
		"type": "skeleton",
		"health_max": 100,
		"damage": 20,
		"loot": {
			1: {
				"chance": 50,
				"type": "healing_bottle"
			},
			2: {
				"chance": 85,
				"type": "gold_coins"
			}
		}
	},
	2: {
		"scene": preload("res://src/02_scenes/02_Characters/02_Enemies/03_Minotaur/Minotaur.tscn"),
		"type": "minotaur",
		"health_max": 200,
		"damage": 45,
		"loot": {
			1: {
				"chance": 50,
				"type": "healing_bottle"
			},
			2: {
				"chance": 85,
				"type": "gold_coins"
			}
		}
	},
	3: {
		"scene": preload("res://src/02_scenes/02_Characters/02_Enemies/04_Ghost/Ghost.tscn"),
		"type": "ghost",
		"health_max": 150,
		"damage": 15,
		"loot": {
			1: {
				"chance": 50,
				"type": "healing_bottle"
			},
			2: {
				"chance": 85,
				"type": "gold_coins"
			}
		}
	},
	4: {
		"scene": preload("res://src/02_scenes/02_Characters/02_Enemies/05_Mage/Mage.tscn"),
		"type": "mage",
		"health_max": 150,
		"damage": 45,
		"loot": {
			1: {
				"chance": 50,
				"type": "healing_bottle"
			},
			2: {
				"chance": 85,
				"type": "gold_coins"
			}
		}
	}
}


var loot_list: Dictionary = {
	"gold_coins": {
		"scene": preload("res://src/02_scenes/04_Items/02_Loot/01_Gold/Gold.tscn"),
		"type": "gold_coins",
		"title": "Gold Coins",
		"min_value": 1,
		"max_value": 5,
	},
	"healing_bottle": {
		"scene": preload("res://src/02_scenes/04_Items/02_Loot/02_HealthPotion/HealthPotion.tscn"),
		"type": "healing_bottle",
		"title": "Healing Bottle",
		"max_value": 1,
	},
}


var boss_loot_list: Dictionary = {
	"key": {
		"scene": preload("res://src/02_scenes/04_Items/02_Loot/03_DungeonKey/DungeonKey.tscn"),
		"type": "key",
		"title": "Door Key",
		"max_value": 1
	}
} 



var lvl_modifiers: Dictionary = {
	"damage": 1.25,
	"max_health": 1.5,
}
