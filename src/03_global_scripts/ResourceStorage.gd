extends Node

export var game_save_class: Script


var player_original_data: Dictionary = {
	"health_current" : 4,
	"health_max": PlayerParams.param_list["max_health"].value,
	"coins_count": 0,
	"healing_pots_count": 0,
}

var player_data: Dictionary = {
	"health_current" : 4,
	"health_max": PlayerParams.param_list["max_health"].value,
	"coins_count": 0,
	"healing_pots_count": 0,
}
