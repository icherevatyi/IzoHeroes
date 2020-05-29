extends Area2D

var spawned:bool = true


func _on_Destroyer_area_entered(area: Area2D) -> void:
	if area.is_in_group("SPAWN_POINT"):
		area.queue_free()
