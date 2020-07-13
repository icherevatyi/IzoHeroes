extends Node

export var game_save_class: Script

func get_param_value(param: String) -> int:
	for key in PlayerParams.param_list.keys():
		if PlayerParams.param_list[key].type == param:
			return PlayerParams.param_list[key].value
	return 0


var player_original_data: Dictionary = {
	"health_current" : 4,
	"health_max": get_param_value("max_health"),
	"coins_count": 0,
	"healing_pots_count": 0,
}

var player_data: Dictionary = {
	"health_current" : 4,
	"health_max": get_param_value("max_health"),
	"coins_count": 0,
	"healing_pots_count": 0,
}
