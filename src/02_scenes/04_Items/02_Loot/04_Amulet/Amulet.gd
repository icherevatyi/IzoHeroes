extends StaticBody2D


onready var float_animation_handler: AnimationPlayer = $FloatAnimator
onready var sprite: Sprite = $Sprite

func _ready() -> void:
	_start_floating()


func _start_floating() -> void:
	float_animation_handler.play("float")

func _on_item_picked_up() -> void:
	queue_free()

