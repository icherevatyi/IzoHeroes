extends Node

var weapon_id: String = "steel_sword"

var stats_list: Dictionary = {
	0: {
		"type": "max_health",
		"title": "Max. Health",
		"description": "0",
		"base_value": 120,
		"value": 120,
		"calculated_final": 120
	},
	1: {
		"type": "max_stamina",
		"title": "Max. Stamina",
		"description": "0",
		"base_value": 100,
		"value": 100,
		"calculated_final": 100
	},
	2: {
		"type": "attack_speed",
		"title": "Atk. Speed",
		"description": "1",
		"base_value": 20,
		"value": 20,
	},
	3: {
		"type": "attack_power",
		"title": "Atk. Power",
		"description": "2",
		"base_value": 45.0,
		"value": 45.0,
	},
	4: {
		"type": "movement_speed",
		"title": "Move Speed",
		"description": "5",
		"base_value": 120.0,
		"value": 120.0,
	},
	5: {
		"type": "dodge_chance",
		"title": "Dodge Chance",
		"description": "3",
		"base_value": 5.0,
		"value": 5.0,
	},
	6: {
		"type": "instakill_chance",
		"title": "Fatal Blow",
		"description": "4",
		"base_value":  8.0,
		"value": 8.0,
	},
}

var perk_list: Dictionary = {
	0: {
		"title": "Fortitude",
		"type": "max_health",
		"description": "Your adventures made you sturdier, from now on foes will have much harder time killing you. Increased maximum health by 35. and maximum stamina by 15",
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
		"description": "Using new technicks, you can strike faster, slising enemies to salad. Attack speed increased by 10%",
		"value": 0.1,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/atckSpeed_glyph.png")
	},
	3: {
		"title": "Light Footed",
		"type": "movement_speed",
		"description": "Light footed means alive. Movement speed is increased by 5%",
		"value": 0.05,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/speed_glyph.png")
		
	},
	4: {
		"title": "Fitted Armor",
		"type": "dodge_chance",
		"description": "Your combat experience allows you to avoid enemy damage. Chance to evade any incoming attack is increased by 15%",
		"value": 0.15,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/armor_glyph.png")
	},
	5: {
		"title": "Combat Vision",
		"type": "instakill_chance",
		"description": "Your eyes are catching enemy weak points. Chance to immediately kill any monster (excluding bosses) is increased by 12%",
		"value": 0.12,
		"perk_lvl": 0,
		"icon": load("res://src/01_assets/01_UI/glyph/battleEye_glyph.png")
	}
}

func _on_weapon_picked_up(weapon_id: String) -> void:
		print(weapon_id)


func update_stat(index: int) -> void:
	for list_item in stats_list:
		if stats_list[list_item].type == perk_list[index].type:
			if stats_list[list_item].type == "max_health":
				stats_list[list_item].value += 35
				stats_list[1].value += 15
			else:
				stats_list[list_item].value += int(round((stats_list[list_item].base_value * perk_list[index].value)))
	perk_list[index].perk_lvl += 1

