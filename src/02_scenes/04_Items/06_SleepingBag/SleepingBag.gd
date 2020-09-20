extends Node2D

var _response: int
var can_rest: bool = false

onready var activation_label: Control = $InterractionIndicator

signal show_label
signal hide_label


func _ready() -> void:
	_response = connect("show_label", activation_label, "_on_indicator_enabled")
	_response = connect("hide_label", activation_label, "_on_indicator_disabled")
	

func _on_PlayerCollisionDetector_body_entered(body) -> void:
	if body.name == "Player":
		body.is_interactive = true
		body.interactive_obj = self
		emit_signal("show_label")


func _on_PlayerCollisionDetector_body_exited(body) -> void:
	if body.name == "Player":
		body.is_interactive = false
		body.interactive_obj = null
		emit_signal("hide_label")


func activate() -> void:
	for body in $PlayerCollisionDetector.get_overlapping_bodies():
		if body.name == "Player":
			body.emit_signal("damage_heal", body.health_scripts.health_max)
