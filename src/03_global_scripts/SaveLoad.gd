extends Node2D

var save_path: String = "res://save_file.cfg"
var config: ConfigFile = ConfigFile.new()
var _save_response: int
var _load_response: int


func save_game() -> void:
	config.set_value("Player", "HealthCurrent", ResourceStorage.player_data.health_current)
	config.set_value("Player", "CoinsCurrent", ResourceStorage.player_data.coins_count)
	config.set_value("Player", "PotionsCurrent", ResourceStorage.player_data.healing_pots_count)
	config.set_value("Player", "SleepingBag", ResourceStorage.player_data.saw_sleeping_bag)
	config.set_value("Player", "WeaponCurrent", PlayerStats.weapon_id)
	config.set_value("Player", "CurrentStats", PlayerStats.stats_list)
	config.set_value("Player", "AquiredPerks", PlayerStats.perk_list)
	config.set_value("Player", "CurrentLvl", ResourceStorage.player_data.current_lvl)
	
	_save_response = config.save(save_path)


func load_game() -> void:
	_load_response = config.load(save_path)
	ResourceStorage.player_data.health_current = config.get_value("Player", "HealthCurrent", ResourceStorage.player_data.health_current)
	ResourceStorage.player_data.coins_count = config.get_value("Player", "CoinsCurrent", ResourceStorage.player_data.coins_count)
	ResourceStorage.player_data.saw_sleeping_bag = config.get_value("Player", "SleepingBag", ResourceStorage.player_data.saw_sleeping_bag)
	ResourceStorage.player_data.current_lvl = config.get_value("Player", "CurrentLvl", ResourceStorage.player_data.current_lvl)
	PlayerStats.weapon_id = config.get_value("Player", "WeaponCurrent", PlayerStats.weapon_id)
	PlayerStats.stats_list = config.get_value("Player", "CurrentStats", PlayerStats.stats_list)
	PlayerStats.perk_list = config.get_value("Player", "AquiredPerks", PlayerStats.perk_list)
	
