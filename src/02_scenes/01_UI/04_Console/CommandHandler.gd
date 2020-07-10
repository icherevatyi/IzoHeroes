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
		"command": "lvl_next",
		"arguments": [] 
	}
}


func add_key() -> void:
	var spawn_position: Vector2 = get_node("/root/Dungeon/YSort/Player").get_global_position()
	var item_instance = Lists.boss_loot_list["key"].scene.instance()
	item_instance.item_info = Lists.boss_loot_list["key"]
	item_instance.set_global_position(spawn_position)
	get_node("/root/Dungeon").add_child(item_instance)


func lvl_next() -> void:
	var rooms = get_node("/root/Dungeon/Rooms").get_children()
	for room_item in rooms:
		for item_element in room_item.get_children():
			if item_element.name == "ExitDoor":
				item_element._load_next_lvl()


func add_potion() -> void:
	pass
