extends Area2D

onready var enemy = get_parent()


func _on_damage_received(damage) -> void:
	enemy.is_taking_damage = true
	enemy.receive_damage(damage)

func _disable_collision_box() -> void:
	$CollisionShape2D.disabled = true
