extends Node2D

enum {
	ARG_BOOL,
	ARG_INT,
	ARG_STRING,
	ARG_FLOAT
}

var command_list: Dictionary = {
	0: {
		"command": "add_item",
		"arguments": [ARG_STRING, ARG_INT]
	},
	1: {
		"command": "show_items",
		"arguments": [] 
	},
	2:{
		"command": "lvl_next",
		"arguments": [] 
	},
	3: {
		"command": "lvl_change_to",
		"arguments": [ARG_INT] 
	},
}


func add_item(item_type: String, item_amount: String) -> String:
	var spawn_position: Vector2 = get_node("/root/Dungeon/YSort/Player").get_global_position()
	if Lists.loot_list.has(item_type):
		var item_instance = Lists.loot_list[item_type].scene.instance()
		item_instance.item_info = Lists.loot_list[item_type]
		item_instance.set_global_position(spawn_position)
		
		get_node("/root/Dungeon").add_child(item_instance)
		
		item_instance.item_local_data.amount = int(item_amount)
		
		return str("Item '", Lists.loot_list[item_type].title, "' was added to the world in quantity of ", item_amount)
		
	elif Lists.boss_loot_list.has(item_type):
		var item_instance = Lists.boss_loot_list[item_type].scene.instance()
		item_instance.item_info = Lists.boss_loot_list[item_type]
		item_instance.set_global_position(spawn_position)
		
		get_node("/root/Dungeon").add_child(item_instance)
		
		item_instance.item_local_data.amount = int(item_amount)
		
		return str("Item '", Lists.boss_loot_list[item_type].title, "' was added to the world in quantity of ", item_amount)
		
	else:
		return str("Failed to execute command, '", item_type, "' not found.")


func show_items() -> String:
	var result: String
	var items_array = Lists.loot_list.keys() + Lists.boss_loot_list.keys()
	for i in items_array.size():
		result = result + "     " + items_array[i] + "\n"
	
	return str("Available items: \n", result)


func lvl_next() -> String:
	var rooms = get_node("/root/Dungeon/Rooms").get_children()
	for room_item in rooms:
		if room_item.name == "ExitDoor":
			room_item._load_next_lvl()
	return "Changing level, please wait"


func lvl_change_to(argument: String) -> String:
	var arg = int(argument)
	Global.current_lvl = arg - 1
	var rooms = get_node("/root/Dungeon/Rooms").get_children()
	for room_item in rooms:
		for item_element in room_item.get_children():
			if item_element.name == "ExitDoor":
				item_element._load_next_lvl()
	return str("Changing dungeon level to ", argument)
		
