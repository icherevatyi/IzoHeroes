extends Node2D

enum {
	ARG_BOOL,
	ARG_INT,
	ARG_STRING,
	ARG_FLOAT
}

var command_list: Dictionary = {
	0: {
		"command": "add_key",
		"arguments": [] 
	},
	1: {
		"command": "add_potion",
		"arguments": [ARG_INT] 
	},
	2: {
		"command": "add_gold",
		"arguments": [ARG_INT] 
	},
	3: {
		"command": "lvl_next",
		"arguments": [] 
	},
	4: {
		"command": "lvl_change_to",
		"arguments": [ARG_INT] 
	}
}


func add_key() -> void:
	var spawn_position: Vector2 = get_node("/root/Dungeon/YSort/Player").get_global_position()
	var item_instance = Lists.boss_loot_list["key"].scene.instance()
	item_instance.item_info = Lists.boss_loot_list["key"]
	item_instance.set_global_position(spawn_position)
	get_node("/root/Dungeon").add_child(item_instance)


func add_potion(argument) -> void:
	var spawn_position: Vector2 = get_node("/root/Dungeon/YSort/Player").get_global_position()
	var arg = int(argument)
	for _i in range(0, arg):
		var item_instance = Lists.loot_list["healing_bottle"].scene.instance()
		item_instance.item_info = Lists.loot_list["healing_bottle"]
		item_instance.set_global_position(spawn_position)
		get_node("/root/Dungeon").add_child(item_instance)


func add_gold(argument) -> void:
	var spawn_position: Vector2 = get_node("/root/Dungeon/YSort/Player").get_global_position()
	var item_instance = Lists.loot_list["gold_coins"].scene.instance()
	item_instance.item_info = Lists.loot_list["gold_coins"]
	item_instance.set_global_position(spawn_position)
	get_node("/root/Dungeon").add_child(item_instance)
	item_instance.item_local_data.amount = int(argument)



func lvl_next() -> void:
	var rooms = get_node("/root/Dungeon/Rooms").get_children()
	for room_item in rooms:
		for item_element in room_item.get_children():
			if item_element.name == "ExitDoor":
				item_element._load_next_lvl()


func lvl_change_to(argument: String) -> void:
	var arg = int(argument)
	Global.current_lvl = arg - 1
	var rooms = get_node("/root/Dungeon/Rooms").get_children()
	for room_item in rooms:
		for item_element in room_item.get_children():
			if item_element.name == "ExitDoor":
				item_element._load_next_lvl()
		
