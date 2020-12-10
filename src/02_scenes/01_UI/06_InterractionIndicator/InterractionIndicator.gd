extends Node2D

var _response: int

var slide_easing_param = Tween.EASE_OUT
var slide_trans_param = Tween.TRANS_BACK

var start_point: Vector2 = Vector2(0, 13)
var end_point: Vector2 = Vector2(0, -48)

var modulation_visible: Color = Color(1, 1, 1, 1)
var modulation_hidden: Color = Color(1, 1, 1, 0)
var activation_time: float = 0.6


onready var parent: Node2D = get_parent()
onready var indicator_container: Control = $InterractionIndicatorParent
onready var sliding_tween: Tween = $InterractionIndicatorParent/SlidingTween
onready var visibility_tween: Tween = $InterractionIndicatorParent/VisibilityTween
onready var button_label: Label = $InterractionIndicatorParent/ButtonLabel

onready var activation_animation_tween: Tween = $InterractionIndicatorParent/ActivationAnimationTween
onready var activation_texure: TextureProgress = $InterractionIndicatorParent/ActivationTexture


func _ready() -> void:
	indicator_container.modulate = Color(1, 1, 1, 0)
	indicator_container._set_position(Vector2(0, 13))


func _on_indicator_enabled() -> void:
	_response = visibility_tween.interpolate_property(indicator_container, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = sliding_tween.interpolate_property(indicator_container, "rect_position", start_point, end_point, 0.4, slide_trans_param, slide_easing_param)
	_response = visibility_tween.start()
	_response = sliding_tween.start()


func _on_indicator_disabled() -> void:
	_response = visibility_tween.interpolate_property(indicator_container, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = sliding_tween.interpolate_property(indicator_container, "rect_position", end_point, start_point, 0.4, slide_trans_param, slide_easing_param)
	_response = visibility_tween.start()
	_response = sliding_tween.start()


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
