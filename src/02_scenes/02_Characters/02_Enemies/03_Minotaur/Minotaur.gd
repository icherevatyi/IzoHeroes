extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

func _ready():
	type = "minotaur"
	_get_stats(type)
	
	emit_signal("initiate_healthpool", health_max)
	loot_scripts.get_loot_table(type)
