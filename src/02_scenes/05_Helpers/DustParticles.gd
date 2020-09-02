extends Particles2D

var is_flipped: bool = false


func _ready() -> void:
	set_emitting(true)
	match is_flipped:
		true:
			get_process_material().gravity.x = 70
		false:
			get_process_material().gravity.x = -70

	yield(get_tree().create_timer(1), "timeout")
	call_deferred("queue_free")
