extends Node2D

onready var exit_point: Node2D = $ExitDoor


func _ready() -> void:
	Backdrop.fade_out()
