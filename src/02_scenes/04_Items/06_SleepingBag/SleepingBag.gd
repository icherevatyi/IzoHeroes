extends Node2D

var _response: int
var is_usable: bool = true

onready var activation_label: Node2D = $InterractionIndicator
onready var bag_not_used: Node2D = $NotUsed
onready var bag_used: Node2D = $Used

signal show_label
signal hide_label
signal start_activation
signal stop_activation


func _ready() -> void:
	_response = connect("show_label", activation_label, "_on_indicator_enabled")
	_response = connect("hide_label", activation_label, "_on_indicator_disabled")
	
	_response = connect("start_activation", activation_label, "_on_activation_started")
	_response = connect("stop_activation", activation_label, "_on_activation_stopped")
	
	bag_not_used.visible = true
	bag_used.visible = false


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
			emit_signal("stop_activation")


func start_activation() -> void:
	emit_signal("start_activation")


func abort_activation() -> void:
	emit_signal("stop_activation")


func activate() -> void:
	for body in $PlayerCollisionDetector.get_overlapping_bodies():
		if body.name == "Player":
			if is_usable == true:
				emit_signal("hide_label")
				Backdrop.fade_in(2.5)
				yield(Backdrop.animation_player, "animation_finished")
				get_tree().paused = true
				body.emit_signal("damage_heal", body.health_scripts.health_max)
				is_usable = false
				bag_not_used.visible = false
				bag_used.visible = true
				get_tree().paused = false
				Backdrop.fade_out()

func show_inactive_message() -> void:
	print("There's no time to rest!")
