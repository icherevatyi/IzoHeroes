extends Node

var param_list: Dictionary = {
	"max_health": {
		"title": "Max. Health",
		"value": 4,
	},
	"attack_speed": {
		"title": "Atk. Speed",
		"value": 3,
	},
	"attack_power": {
		"title": "Atk. Power",
		"value": 35.0,
	},
	"dodge_chance": {
		"title": "Dodge Chance",
		"value": 0.05,
	},
	"instakill_chance": {
		"title": "Fatal Blow",
		"value": 0.01,
	},
	"movement_speed": {
		"title": "Move Speed",
		"value": 120.0,
	},
}

var perk_list: Dictionary = {
	0: {
		"title": "Fortitude",
		"type": "max_health",
		"description": "Your adventures made you stronger, from now on foes will have much harder time killing you. Increased maximum health by 1.",
		"value": 1,
		"perk_lvl": 1,
	},
	1: {
		"title": "Strike Power",
		"type": "attack_power",
		"description": "You became stronger, your attack is now 15% more devastating.",
		"value": 0.15,
		"perk_lvl": 1,
	},
	2: {
		"title": "Swing Speed",
		"type": "attack_speed",
		"description": "Using new technicks, you can strike faster, slising enemies to salad. Attack speed increased by 10%",
		"value": 0.1,
		"perk_lvl": 1,
	},
	3: {
		"title": "Light Footed",
		"type": "movement_speed",
		"description": "Light footed means alive. Movement speed is increased by 5%",
		"value": 0.05,
		"perk_lvl": 1,
		
	},
	4: {
		"title": "Combat Luck",
		"type": "dodge_chance",
		"description": "Your combat experience allows you to avoid enemy damage. Chance to evade any incoming attack is increased by 3%",
		"value": 0.03,
		"perk_lvl": 1,
	},
	5: {
		"title": "Hawk Eyes",
		"type": "instakill_chance",
		"description": "Your eyes are catching enemy weak points. Chance to immediately kill any monster (excluding bosses) is increased by 3%",
		"value": 0.03,
		"perk_lvl": 1,
	}
}

func update_param(type: String) -> void:
	var modifier: float = perk_list[type].value
	param_list[type].value += modifier
