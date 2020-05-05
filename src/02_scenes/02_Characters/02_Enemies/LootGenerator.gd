extends Node

var loot_table: Dictionary
var rng = RandomNumberGenerator.new()


func get_loot_table(enemy_type) -> void:
	for index in Lists.enemy_list:
		if enemy_type == Lists.enemy_list[index].type:
			loot_table = Lists.enemy_list[index].loot


func generate_loot() -> void:
	for index in loot_table:
		rng.randomize()
		var drop_chance_value: int = rng.randi_range(0, 100)
		
		if drop_chance_value < loot_table[index].chance:
			print(loot_table[index].type)
