extends RigidBody2D

var _response: int
var weapon_type: String

var direction_list: Dictionary = {
	0: Vector2(0, -150),
	1: Vector2(0, 150),
	2: Vector2(150, 0),
	3: Vector2(-150, 0)
}
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var activation_label: Node2D = $InterractionIndicator

signal show_label
signal hide_label
signal start_activation
signal stop_activation
signal take_weapon(weapon_type, weapon_position)

func _ready() -> void:
	_response = connect("show_label", activation_label, "_on_indicator_enabled")
	_response = connect("hide_label", activation_label, "_on_indicator_disabled")

	_response = connect("start_activation", activation_label, "_on_activation_started")
	_response = connect("stop_activation", activation_label, "_on_activation_stopped")

	apply_central_impulse(_select_direction())


func _on_Timer_timeout() -> void:
	sleeping = true
	set_collision_layer_bit(3, true)


func _select_direction() -> Vector2:
	rng.randomize()
	var rand_dir = rng.randi_range(0, 3)
	return direction_list[rand_dir]


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
		emit_signal("stop_activation")


func start_activation() -> void:
	emit_signal("start_activation")


func abort_activation() -> void:
	emit_signal("stop_activation")


func activate() -> void:
	for body in $PlayerCollisionDetector.get_overlapping_bodies():
		if body.name == "Player":
			_response = connect("take_weapon", body, "_on_weapon_taken")
			
			emit_signal("hide_label")
			emit_signal("take_weapon", weapon_type, get_global_position())
			
			disconnect("show_label", activation_label, "_on_indicator_enabled")
			disconnect("hide_label", activation_label, "_on_indicator_disabled")
			disconnect("start_activation", activation_label, "_on_activation_started")
			disconnect("stop_activation", activation_label, "_on_activation_stopped")
			disconnect("take_weapon", body, "_on_weapon_taken")
			
			queue_free()

