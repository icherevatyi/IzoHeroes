extends Label

var _tween_response

onready var notif_moving_start = Vector2(0, get_viewport().size.y)
onready var notif_moving_finish = Vector2(0, get_viewport().size.y + 100)

onready var tween: Tween = $Tween


func _ready() -> void:
	_tween_response = tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0),  2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween_response = tween.start()
	
	yield(tween, "tween_all_completed")
	queue_free()


func _on_message_shown() -> void:
	pass
