extends Node2D

var _response: int
var is_usable: bool = true

onready var activation_label: Control = $InterractionIndicator

signal show_label
signal hide_label


func _ready() -> void:
	_response = connect("show_label", activation_label, "_on_indicator_enabled")
	_response = connect("hide_label", activation_label, "_on_indicator_disabled")
	

func _on_PlayerCollisionDetector_body_entered(body) -> void:
	if body.name == "Player":
		if is_usable == true:
			body.is_interactive = true
			emit_signal("show_label")
		body.interactive_obj = self


func _on_PlayerCollisionDetector_body_exited(body) -> void:
	if body.name == "Player":
		body.is_interactive = false
		body.interactive_obj = null
		if is_usable == true:
			emit_signal("hide_label")


func activate() -> void:
	for body in $PlayerCollisionDetector.get_overlapping_bodies():
		if body.name == "Player":
			if is_usable == true:
				emit_signal("hide_label")
				body.emit_signal("damage_heal", body.health_scripts.health_max)
				is_usable = false


func show_inactive_message() -> void:
	print("There's no time to rest!")
