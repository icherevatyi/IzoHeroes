extends CanvasLayer

var heart_point: PackedScene = preload("res://src/02_scenes/01_UI/01_Elements/Heart.tscn")

onready var healthbar = $Control/HealthBar


func _ready() -> void:
	_on_health_restored(4)


func _on_health_restored(amount: int) -> void:
	for healthpoint in amount:
		var _h_instance = heart_point.instance()
		healthbar.add_child(_h_instance)


func _on_damage_taken(dmg_taken: int) -> void:
	var _health_pool = healthbar.get_children()
	if _health_pool.size() >= dmg_taken:
		for health_point in dmg_taken:
			_health_pool[health_point].queue_free()
	else:
		dmg_taken = _health_pool.size()
		_on_damage_taken(dmg_taken)
