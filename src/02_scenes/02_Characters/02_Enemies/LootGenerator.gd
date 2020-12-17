extends Node

var loot_table: Dictionary
var rng = RandomNumberGenerator.new()
var is_generated: bool = false

onready var parent: KinematicBody2D = get_node("../../")
onready var dungeon: Node2D = get_node("/root/Dungeon/YSort")


func get_loot_table(enemy_type) -> void:
	for index in Lists.enemy_list:
		if enemy_type == Lists.enemy_list[index].type:
			loot_table = Lists.enemy_list[index].loot
	if parent.drops_key == true:
		loot_table[loot_table.size() + 1] = Lists.boss_loot_list["key"]


func generate_loot() -> void:
	if is_generated == false:
		for index in loot_table:
			rng.randomize()
			var drop_chance_value: int = rng.randi_range(0, 100)
			
			if drop_chance_value < loot_table[index].chance:
				var dropped_item = loot_table[index].type
				var item_instance: RigidBody2D = Lists.loot_list[dropped_item].scene.instance()
				item_instance.item_info = Lists.loot_list[dropped_item]
				item_instance.set_global_position(parent.get_global_position())
				dungeon.add_child(item_instance)

		if parent.drops_key == true:
			var key_instance: RigidBody2D = Lists.boss_loot_list["key"].scene.instance()
			key_instance.item_info = Lists.boss_loot_list["key"]
			key_instance.set_global_position(parent.get_global_position())
			dungeon.add_child(key_instance)
		if parent.is_boss == true:
			for weapon_holder in Lists.weapon_list:
				rng.randomize()
				var drop_chance_value: int = rng.randi_range(0, 100)
				
				if parent.type == Lists.weapon_list[weapon_holder].dropped and drop_chance_value < 30:
					var weapon_instance = Lists.weapon_list[weapon_holder].loot_scene.instance()
					weapon_instance.set_global_position(parent.get_global_position())
					dungeon.add_child(weapon_instance)

		is_generated = true
