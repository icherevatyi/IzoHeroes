extends Node2D

var _response: int

onready var activation_label: Control = $InterractionIndicator

signal show_label
signal hide_label


func _ready() -> void:
	_response = connect("show_label", activation_label, "_on_indicator_enabled")
	_response = connect("hide_label", activation_label, "_on_indicator_disabled")
	

func _on_PlayerCollisionDetector_body_entered(body) -> void:
	if body.name == "Player":
		emit_signal("show_label")


func _on_PlayerCollisionDetector_body_exited(body) -> void:
	if body.name == "Player":
		emit_signal("hide_label")
