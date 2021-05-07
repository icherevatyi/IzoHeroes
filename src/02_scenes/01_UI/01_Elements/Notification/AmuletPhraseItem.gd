extends Node2D

func _ready():
	get_node("Tween").interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").start()
	get_node("Timer").set_wait_time(2)
	get_node("Timer").start()


func _on_phrase_initiated(phrase_t: String) -> void:
	$Label.set_text(phrase_t)


func phrase_delete() -> void:
	get_node("Tween").interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").start()
	yield(get_tree().create_timer(0.8), "timeout")
	call_deferred("queue_free")


func _on_Timer_timeout():
	phrase_delete()
