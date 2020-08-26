extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

onready var hitbox: CollisionShape2D = $HitBox/CollisionShape2D

func _ready():
	type = "mage"
	_get_stats(type)
	hitbox.disabled = true
	
	emit_signal("initiate_healthpool", health_max)
	loot_scripts.get_loot_table(type)
