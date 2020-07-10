extends Node2D

enum {
	ARG_BOOL,
	ARG_INT,
	ARG_STRING,
	ARG_FLOAT
}

onready var dungeon = get_node("/root/Dungeon")
onready var player = get_node("/root/Dungeon/YSort/Player")

var command_list: Dictionary = {
	0: {
		"command": "add_key",
		"arguments": [] 
	},
	1: {
		"command": "add_potion",
		"arguments": [ARG_INT] 
	}
}


func add_key() -> void:
	var spawn_position: Vector2 = player.get_global_position()
	var item_instance = Lists.boss_loot_list["key"].scene.instance()
	item_instance.item_info = Lists.boss_loot_list["key"]
	item_instance.set_global_position(spawn_position)
	dungeon.add_child(item_instance)


func add_potion() -> void:
	pass
