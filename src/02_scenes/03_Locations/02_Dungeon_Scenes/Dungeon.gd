extends Node2D

onready var exit_point: Node2D = $ExitDoor


func _ready() -> void:
	Backdrop.fade_out()

func _on_lvl_end_reached() -> void:
	# call to backdrop, when finished - change lvl or show endgame message
	
	pass
