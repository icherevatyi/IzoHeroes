extends Node


var level_messages: Dictionary = {
	"entrance_closed": "Rusty gate closed behind you. It is tightly sealed and the only way to leave this place is to move forward.",
	"no_key": "You need a key, it should be carried by someone here.",
	"have_key": "Old key is laying in your pocket, picked from and ugly abomination of foul magic. Are you sure you want to open the gate lock?",
	"demo_end": "You reached end of this demo, thank you for playing!"
}

var exhaustion_messages: Dictionary = {
	0: "I'm tired.",
	1: "I am exhausted.",
	2: "My arms are so heavy.",
	3: "I need time to rest.",
	4: "Give me some time."
}

var player_pickup_sounds: Dictionary = {
	0: load("res://src/01_assets/09_Audio/s_items/item_pick-01.ogg"),
	1: load("res://src/01_assets/09_Audio/s_items/item_pick-02.ogg"),
	2: load("res://src/01_assets/09_Audio/s_items/item_pick-03.ogg"),
	3: load("res://src/01_assets/09_Audio/s_items/item_pick-04.ogg"),
	4: load("res://src/01_assets/09_Audio/s_items/item_pick-05.ogg"),
	5: load("res://src/01_assets/09_Audio/s_items/item_pick-06.ogg"),
}

var player_footsteps_sounds: Dictionary = {
	0: load("res://src/01_assets/09_Audio/s_character/steps/player_step-01.ogg"),
	1: load("res://src/01_assets/09_Audio/s_character/steps/player_step-02.ogg"),
	2: load("res://src/01_assets/09_Audio/s_character/steps/player_step-03.ogg"),
	3: load("res://src/01_assets/09_Audio/s_character/steps/player_step-04.ogg"),
	4: load("res://src/01_assets/09_Audio/s_character/steps/player_step-05.ogg"),
	5: load("res://src/01_assets/09_Audio/s_character/steps/player_step-06.ogg"),
	6: load("res://src/01_assets/09_Audio/s_character/steps/player_step-07.ogg"),
	7: load("res://src/01_assets/09_Audio/s_character/steps/player_step-08.ogg"),
	8: load("res://src/01_assets/09_Audio/s_character/steps/player_step-08.ogg"),
}

var player_hurt_sounds: Dictionary = {
	0: load("res://src/01_assets/09_Audio/s_character/hurt/player_hurt-01.ogg"),
	1: load("res://src/01_assets/09_Audio/s_character/hurt/player_hurt-02.ogg"),
	2: load("res://src/01_assets/09_Audio/s_character/hurt/player_hurt-03.ogg"),
	3: load("res://src/01_assets/09_Audio/s_character/hurt/player_hurt-04.ogg"),
	4: load("res://src/01_assets/09_Audio/s_character/hurt/player_hurt-05.ogg"),
	5: load("res://src/01_assets/09_Audio/s_character/hurt/player_hurt-06.ogg"),
}

var player_hit_enemy: Dictionary = {
	0: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_hit-01.ogg"),
	1: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_hit-02.ogg"),
	2: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_hit-03.ogg"),
	3: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_hit-04.ogg"),
}

var player_death_sound: Resource = load("res://src/01_assets/09_Audio/s_character/death/player_death.ogg")

var weapon_swing_sounds: Dictionary = {
	0: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_swing-01.ogg"),
	1: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_swing-02.ogg"),
	2: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_swing-03.ogg"),
	3: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_swing-04.ogg"),
	4: load("res://src/01_assets/09_Audio/s_character/weapon/weapon_swing-05.ogg"),
}

var sound_enemy_walk: Dictionary =  {
	"skeleton": {
		0: load("res://src/01_assets/09_Audio/s_enemies/skeleton/bones_walk-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_enemies/skeleton/bones_walk-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_enemies/skeleton/bones_walk-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_enemies/skeleton/bones_walk-04.ogg"),
		4: load("res://src/01_assets/09_Audio/s_enemies/skeleton/bones_walk-05.ogg"),
		5: load("res://src/01_assets/09_Audio/s_enemies/skeleton/bones_walk-06.ogg"),
		6: load("res://src/01_assets/09_Audio/s_enemies/skeleton/bones_walk-07.ogg"),
		7: load("res://src/01_assets/09_Audio/s_enemies/skeleton/bones_walk-08.ogg"),
	},
	"ghost": {
		0: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_walk-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_walk-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_walk-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_walk-04.ogg"),
		4: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_walk-05.ogg"),
		5: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_walk-06.ogg"),
		6: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_walk-06.ogg"),
		7: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_walk-06.ogg"),
	}
}

var sound_enemy_attack: Dictionary = {
	"skeleton": {
		0: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_attack-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_attack-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_attack-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_attack-04.ogg"),
		4: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_attack-05.ogg"),
		5: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_attack-06.ogg"),
	},
	"ghost": {
		0: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_attack-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_attack-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_attack-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_attack-04.ogg"),
		4: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_attack-05.ogg"),
	}
}

var sound_enemy_hurt: Dictionary = {
	"skeleton": {
		0: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_hurt-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_hurt-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_hurt-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_hurt-04.ogg"),
		4: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_hurt-05.ogg"),
		5: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_hurt-06.ogg"),
		6: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_hurt-07.ogg"),
		7: load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton_hurt-08.ogg"),
	},
	"ghost": {
		0: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_hurt-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_hurt-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_hurt-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_hurt-04.ogg"),
		4: load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_hurt-05.ogg"),
	}
}

var sound_enemy_death: Dictionary = {
	"skeleton": load("res://src/01_assets/09_Audio/s_enemies/skeleton/skeleton death.ogg"),
	"ghost": load("res://src/01_assets/09_Audio/s_enemies/ghost/ghost_death.ogg")
}

var sound_item_drop: Dictionary = {
	"healing_bottle": {
		0: load("res://src/01_assets/09_Audio/s_items/bottle_drop-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_items/bottle_drop-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_items/bottle_drop-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_items/bottle_drop-04.ogg"),
		4: load("res://src/01_assets/09_Audio/s_items/bottle_drop-05.ogg"),
		5: load("res://src/01_assets/09_Audio/s_items/bottle_drop-06.ogg"),
		6: load("res://src/01_assets/09_Audio/s_items/bottle_drop-07.ogg"),
	},
	"gold_coins": {
		0: load("res://src/01_assets/09_Audio/s_items/bottle_drop-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_items/bottle_drop-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_items/bottle_drop-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_items/bottle_drop-04.ogg"),
		4: load("res://src/01_assets/09_Audio/s_items/bottle_drop-05.ogg"),
		5: load("res://src/01_assets/09_Audio/s_items/bottle_drop-06.ogg"),
		6: load("res://src/01_assets/09_Audio/s_items/bottle_drop-07.ogg"),
	},
	"weapon": {
		0: load("res://src/01_assets/09_Audio/s_items/sword_drop-01.ogg"),
		1: load("res://src/01_assets/09_Audio/s_items/sword_drop-02.ogg"),
		2: load("res://src/01_assets/09_Audio/s_items/sword_drop-03.ogg"),
		3: load("res://src/01_assets/09_Audio/s_items/sword_drop-04.ogg"),
	},
	"key": {
		0: load("res://src/01_assets/09_Audio/s_items/key_drop.ogg")
	}
}

var healing_used: Resource = load("res://src/01_assets/09_Audio/s_ui/bottle_drink-01.ogg")
var key_used: Resource
var door_closed: Resource
var door_opened: Resource


 


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

var weapon_list: Dictionary = {
	"steel_sword": {
		"title": "Steel Sword",
		"type": "steel_sword",
		"attack_power": 40,
		"attack_speed": 23,
		"crit_mult": 1.4,
		"stamina_usage": 13,
		"dropped": "skeleton",
		"loot_scene": preload("res://src/02_scenes/04_Items/02_Loot/05_WeaponDrop/SteelSword/Sword.tscn")
	},
	"blood_falchion": {
		"title": "Blood Falchion",
		"type": "blood_falchion",
		"attack_power": 30,
		"attack_speed": 27,
		"crit_mult": 2.4,
		"stamina_usage": 8,
		"dropped": "ghost",
		"loot_scene": preload("res://src/02_scenes/04_Items/02_Loot/05_WeaponDrop/BloodFalchion/BloodFalchion.tscn")
	},
	"jade_dadao": {
		"title": "Jade Dadao",
		"type": "jade_dadao",
		"attack_power": 48,
		"attack_speed": 18,
		"crit_mult": 1.8,
		"stamina_usage": 18,
		"dropped": "mage",
		"loot_scene": preload("res://src/02_scenes/04_Items/02_Loot/05_WeaponDrop/JadeDadao/JadeDadao.tscn")
	},
	"great_axe": {
		"title": "Great Axe",
		"type": "great_axe",
		"attack_power": 56,
		"attack_speed": 13,
		"crit_mult": 2.0,
		"stamina_usage": 30,
		"dropped": "minotaur",
		"loot_scene": preload("res://src/02_scenes/04_Items/02_Loot/05_WeaponDrop/GreatAxe/GreatAxe.tscn")
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
