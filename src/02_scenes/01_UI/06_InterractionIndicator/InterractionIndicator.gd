extends Control

var _response: int

var slide_easing_param = Tween.EASE_OUT
var slide_trans_param = Tween.TRANS_BACK

var start_point: Vector2 = Vector2(0, 13)
var end_point: Vector2 = Vector2(0, -19)


onready var parent: Node2D = get_parent()

onready var sliding_tween: Tween = $SlidingTween
onready var visibility_tween: Tween = $VisibilityTween
onready var button_label: Label = $ButtonLabel

onready var activation_animation_tween: Tween = $ActivationAnimationTween
onready var activation_slider: ColorRect = $ActivationSlider


func _ready() -> void:
	button_label.modulate = Color(1, 1, 1, 0)
	button_label._set_position(Vector2(0, 13))
	
	activation_slider.modulate = Color(1, 1, 1, 1)
	activation_slider._set_size(Vector2(0, 3))


func _on_indicator_enabled() -> void:
	_response = visibility_tween.interpolate_property(button_label, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = sliding_tween.interpolate_property(button_label, "rect_position", start_point, end_point, 0.4, slide_trans_param, slide_easing_param)
	_response = visibility_tween.start()
	_response = sliding_tween.start()


func _on_indicator_disabled() -> void:
	_response = visibility_tween.interpolate_property(button_label, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = sliding_tween.interpolate_property(button_label, "rect_position", end_point, start_point, 0.4, slide_trans_param, slide_easing_param)
	_response = visibility_tween.start()
	_response = sliding_tween.start()


func _on_activation_started() ->  void:
	activation_slider.modulate = Color(1, 1, 1, 1)
	_response = activation_animation_tween.interpolate_property(activation_slider, "rect_size", Vector2(0, 3), Vector2(40, 3), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = activation_animation_tween.resume_all()
	_response = activation_animation_tween.start()


func _on_activation_stopped() -> void:
	activation_slider.modulate = Color(1, 1, 1, 0)
	activation_slider._set_size(Vector2(0, 3))
	_response = activation_animation_tween.stop(activation_slider)


func _on_ActivationAnimationTween_tween_all_completed() -> void:
	parent.activate()
	activation_slider.modulate = Color(1, 1, 1, 0)
	activation_slider._set_size(Vector2(0, 3))
