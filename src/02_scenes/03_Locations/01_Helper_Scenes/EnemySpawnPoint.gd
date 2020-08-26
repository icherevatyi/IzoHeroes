extends Position2D

onready var spawn_container = get_node("/root/Dungeon/YSort")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	spawn_enemy(get_enemy_type())


func get_enemy_type() -> String:
	rng.randomize()
	var rng_number: int = rng.randi_range(0, 10)
	if rng_number >= 4 and rng_number < 8:
		return "ghost"
	if rng_number >= 8 and rng_number < 9:
		return "minotaur"
	if rng_number >= 9:
		return "mage"
	return "skeleton"


func spawn_enemy(type) -> void:
	for enemy in Lists.enemy_list:
		if Lists.enemy_list[enemy].type == type:
			var enemy_instance = Lists.enemy_list[enemy].scene.instance()
			enemy_instance.set_global_position(get_global_position())
			spawn_container.call_deferred("add_child", enemy_instance)
