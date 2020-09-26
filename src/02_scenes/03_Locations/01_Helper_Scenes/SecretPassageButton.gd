extends Area2D

var _response: int
var is_usable: bool = true
var player_obj


onready var animated_sprite: AnimatedSprite = $Sprite
onready var activation_label: Control = $InterractionIndicator
onready var btn_animation_player: AnimationPlayer = $ButtonAnimationPlayer

signal show_label
signal hide_label
signal start_activation
signal stop_activation
signal open_secret_door


func _ready() -> void:
	_response = connect("show_label", activation_label, "_on_indicator_enabled")
	_response = connect("hide_label", activation_label, "_on_indicator_disabled")
	
	_response = connect("start_activation", activation_label, "_on_activation_started")
	_response = connect("stop_activation", activation_label, "_on_activation_stopped")
	
	
	_response = connect("open_secret_door", get_parent(), "_on_secret_door_opened")
	btn_animation_player.play("idle")


func _on_SecretPassageButton_body_entered(body) -> void:
	if body.name == "Player":
		if is_usable == true:
			body.is_interactive = true
			player_obj = body
			emit_signal("show_label")
		body.interactive_obj = self


func _on_SecretPassageButton_body_exited(body) -> void:
	if body.name == "Player":
		player_obj = null
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
	for body in get_overlapping_bodies():
		if body.name == "Player":
			if is_usable == true:
				emit_signal("hide_label")
				is_usable = false
				btn_animation_player.play("activation")


func activated() -> void:
	emit_signal("open_secret_door")
	yield(get_tree().create_timer(1), "timeout")
	player_obj.camera.start_shaking(2, 30, 1.5)
