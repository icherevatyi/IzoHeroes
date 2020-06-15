extends Position2D

onready var spawn_container = get_node("/root/Dungeon/YSort")


func _ready() -> void:
	spawn_enemy("skeleton")


func spawn_enemy(type) -> void:
	for enemy in Lists.enemy_list:
		if Lists.enemy_list[enemy].type == type:
			var enemy_instance = Lists.enemy_list[enemy].scene.instance()
			enemy_instance.set_global_position(get_global_position())
			spawn_container.call_deferred("add_child", enemy_instance)
