extends Node2D

var save_path: String = "res://save_file.cfg"
var config: ConfigFile = ConfigFile.new()
var _save_response: int
var _load_response: int


func save_game() -> void:
	config.set_value("Player", "HealthCurrent", ResourceStorage.player_data.health_current)
	config.set_value("Dungeon", "SavedLvl", ResourceStorage.saved_lvl)
	_save_response = config.save(save_path)


func load_game() -> void:
	_load_response = config.load(save_path)
	ResourceStorage.player_data.health_current = config.get_value("Player", "HealthCurrent", ResourceStorage.player_data.health_current)
	ResourceStorage.saved_lvl = config.get_value("Dungeon", "SavedLvl", ResourceStorage.saved_lvl)

