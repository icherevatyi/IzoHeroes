extends Area2D

onready var enemy = get_parent()


func _on_damage_received(damage) -> void:
	enemy.receive_damage(damage)
