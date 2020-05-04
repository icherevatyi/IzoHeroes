extends Node

export var game_save_class: Script

var player_data: Dictionary = {
	"health_current" : 4,
	"health_max": 8,
	"position": Vector2(0, 0),
}

var saved_lvl: int = 1
