extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

var dust_particles: PackedScene = preload("res://src/02_scenes/05_Helpers/DustParticles.tscn")


func _ready():
	movement_scripts.initial_speed = 45
	type = "minotaur"
	_get_stats(type)
	
	emit_signal("initiate_healthpool", health_max)
	loot_scripts.get_loot_table(type)


func _create_dust() -> void:
	var dungeon = get_node("/root/Dungeon")
	var dust_instance = dust_particles.instance()
	if $Sprite.flip_h == false:
		$DustPoint.position.x = 9
		dust_instance.is_flipped = false
	else:
		$DustPoint.position.x = -9
		dust_instance.is_flipped = true
	dust_instance.set_global_position($DustPoint.get_global_position())
	dungeon.add_child(dust_instance)
