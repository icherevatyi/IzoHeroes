extends CanvasLayer

onready var parent_container: Control = $Control


func _ready():
	parent_container.visible = false


func toggle_console() -> void:
	parent_container.visible = !parent_container.visible
