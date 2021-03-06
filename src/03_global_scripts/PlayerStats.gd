extends Node

var weapon_default: String = Lists.weapon_list["steel_sword"].type
var weapon_id: String = Lists.weapon_list["steel_sword"].type

var stats_list: Dictionary = {
	0: {
		"type": "max_health",
		"title": "Max. Health",
		"base_value": 120,
		"value": 120
	},
	1: {
		"type": "max_stamina",
		"title": "Max. Stamina",
		"base_value": 100,
		"value": 100
	},
	2: {
		"type": "attack_speed",
		"title": "Atk. Speed",
		"base_value": 20,
		"value": 20,
	},
	3: {
		"type": "attack_power",
		"title": "Atk. Power",
		"base_value": 45.0,
		"value": 45.0,
	},
	4: {
		"type": "movement_speed",
		"title": "Movement Speed",
		"base_value": 120.0,
		"value": 120.0,
	},
	5: {
		"type": "dodge_chance",
		"title": "Dodge Chance",
		"base_value": 5.0,
		"value": 5.0,
	},
	6: {
		"type": "crit_chance",
		"title": "Crit. Chance",
		"base_value":  8.0,
		"value": 8.0,
	},
}

var perk_list: Dictionary = {
	0: {
		"title": "Fortitude",
		"type": "max_health",
		"description": "Your adventures made you sturdier, from now on foes will have much harder time killing you. Increased maximum health by 35. and maximum stamina by 15.",
		"value": 35,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/fortitude_glyph.png")
	},
	1: {
		"title": "Strike Power",
		"type": "attack_power",
		"description": "You became stronger, your attack is now 15% more devastating.",
		"value": 0.15,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/power_glyph.png")
	},
	2: {
		"title": "Swing Speed",
		"type": "attack_speed",
		"description": "Using new techniques, you can strike faster, slicing enemies to salad. Attack speed increased by 10%.",
		"value": 0.1,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/atckSpeed_glyph.png")
	},
	3: {
		"title": "Light-Footed",
		"type": "movement_speed",
		"description": "Light-footed means alive. Movement speed is increased by 5%.",
		"value": 0.05,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/speed_glyph.png")
		
	},
	4: {
		"title": "Fitted Armor",
		"type": "dodge_chance",
		"description": "Your combat experience allows you to avoid enemy damage. Chance to evade any incoming attack is increased by 15%.",
		"value": 0.15,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/armor_glyph.png")
	},
	5: {
		"title": "Vicious Strikes",
		"type": "crit_chance",
		"description": "Your eyes are catching enemy weak points. Chance to inflict critical damage is increased by 12%.",
		"value": 0.12,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/battleEye_glyph.png")
	}
}

func reset_params() -> void:
	for stat in stats_list:
		stats_list[stat].value = stats_list[stat].base_value
	for param in PlayerStats.stats_list:
		stats_list[param].value = stats_list[param].base_value
	
	weapon_id = weapon_default
	update_weapon_params(weapon_default)


func _on_weapon_picked_up(w_id: String = weapon_default) -> void:
	weapon_id = w_id
	update_weapon_params(weapon_id)


func update_weapon_params(w_type: String = weapon_default ) -> void:
	var weapon_stats
	for weapon in Lists.weapon_list:
		if weapon == w_type:
			weapon_stats = weapon

	for stat_item in stats_list:
		for weapon_characteristic in Lists.weapon_list[weapon_stats]:
			if stats_list[stat_item].type == weapon_characteristic:
				stats_list[stat_item].base_value = Lists.weapon_list[weapon_stats].get(weapon_characteristic)
				_recalculate_stats(stat_item, stats_list[stat_item].type)


func _recalculate_stats(stat_id: int, stat: String) -> void:
	for perk_item in perk_list:
		if perk_list[perk_item].type == stat:
			if perk_list[perk_item].perk_lvl == 0:
				stats_list[stat_id].value = stats_list[stat_id].base_value
			else:
				stats_list[stat_id].value = stats_list[stat_id].base_value + int(round((stats_list[stat_id].base_value * perk_list[perk_item].value) * perk_list[perk_item].perk_lvl))


func update_stat(index: int) -> void:
	for list_item in stats_list:
		if stats_list[list_item].type == perk_list[index].type:
			if stats_list[list_item].type == "max_health":
				stats_list[list_item].value += 35
				stats_list[1].value += 15
			else:
				stats_list[list_item].value += int(round((stats_list[list_item].base_value * perk_list[index].value)))
	perk_list[index].perk_lvl += 1

