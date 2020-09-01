extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

var skull_scene: PackedScene = preload("res://src/02_scenes/04_Items/03_EnemyMagic/02_MagicSkull/MagicSkull.tscn")
onready var hitbox: CollisionShape2D = $HitBox/CollisionShape2D
onready var skull_spawn: Position2D = $SkullSpawn


func _ready():
	type = "ghost"
	_get_stats(type)
	hitbox.disabled = true
	
	emit_signal("initiate_healthpool", health_max)
	loot_scripts.get_loot_table(type)



func _get_coords() -> Vector2:
	for body in attack_range.get_overlapping_bodies():
		if body.name == "Player":
			return body.get_global_position()
		else:
			return player_coords


func _create_skull() -> void:
	var skull_instance: RigidBody2D = skull_scene.instance()
	var world_node: Node2D = get_node("/root/Dungeon/YSort")
	skull_instance.set_global_position(skull_spawn.get_global_position())
	skull_instance.rotation = get_angle_to(_get_coords())
#	skull_instance.apply_impulse(Vector2(), Vector2(15, 0))
	world_node.add_child(skull_instance)
	
