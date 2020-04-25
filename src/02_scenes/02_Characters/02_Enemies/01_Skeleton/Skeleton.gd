extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

func _ready():
	type = "Skeleton"
	_get_stats(type)
	
	emit_signal("initiate_healthpool", health_max)
	print(health_current)
