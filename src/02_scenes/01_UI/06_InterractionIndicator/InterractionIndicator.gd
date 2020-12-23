extends Node2D

var _response: int


var modulation_visible: Color = Color(1, 1, 1, 1)
var modulation_hidden: Color = Color(1, 1, 1, 0)
var activation_time: float = 0.6


onready var parent: Node2D = get_parent().get_owner()
onready var indicator_container: Control = $InterractionIndicatorParent
onready var visibility_tween: Tween = $VisibilityTween
onready var button_label: Label = $InterractionIndicatorParent/ButtonLabel

onready var title: TextureRect = $ItemTitle
onready var description: TextureRect = $ItemDescription

onready var activation_animation_tween: Tween = $ActivationAnimationTween
onready var activation_texure: TextureProgress = $InterractionIndicatorParent/ActivationTexture


func _ready() -> void:
	indicator_container.modulate = Color(1, 1, 1, 0)
	title.modulate = Color(1, 1, 1, 0)
	description.modulate = Color(1, 1, 1, 0)


func _on_indicator_enabled() -> void:
	_response = visibility_tween.interpolate_property(indicator_container, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = visibility_tween.start()
	yield(get_tree().create_timer(0.03), "timeout")
	_response = visibility_tween.interpolate_property(title, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = visibility_tween.start()
	yield(get_tree().create_timer(0.04), "timeout")
	_response = visibility_tween.interpolate_property(description, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = visibility_tween.start()


func _on_indicator_disabled() -> void:
	_response = visibility_tween.interpolate_property(indicator_container, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = visibility_tween.interpolate_property(title, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = visibility_tween.interpolate_property(description, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = visibility_tween.start()


func _on_activation_started() ->  void:
	_response = activation_animation_tween.interpolate_property(activation_texure, "value", 0, 100, activation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = activation_animation_tween.resume_all()
	_response = activation_animation_tween.start()


func _on_activation_stopped() -> void:
	activation_texure.value = 0
	_response = activation_animation_tween.stop(activation_texure)


func _on_ActivationAnimationTween_tween_all_completed() -> void:
	parent.activate()
	activation_texure.value = 100
