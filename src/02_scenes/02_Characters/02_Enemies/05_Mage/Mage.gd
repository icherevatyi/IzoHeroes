extends "res://src/02_scenes/02_Characters/02_Enemies/Enemy.gd"

var magic_circle: PackedScene = preload("res://src/02_scenes/04_Items/03_EnemyMagic/01_MagicCircle/MagicCircle.tscn")


onready var hitbox: CollisionShape2D = $HitBox/CollisionShape2D

func _ready():
	movement_scripts.initial_speed = 20
	type = "mage"
	_get_stats(type)
	hitbox.disabled = true
	
	emit_signal("initiate_healthpool", health_max)
	loot_scripts.get_loot_table(type)

func _get_coords() -> Vector2:
	for body in attack_range.get_overlapping_bodies():
		if body.name == "Player":
			return body.get_global_position()
		return player_coords
	return Vector2(0, 0)


func _create_circle() -> void:
	var circle_instance: Area2D = magic_circle.instance()
	var world_node: Node2D = get_node("/root/Dungeon/YSort")
	circle_instance.damage = Lists.enemy_list[4].damage
	circle_instance.set_global_position(_get_coords())
	world_node.add_child(circle_instance)
