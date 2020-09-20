extends Control

var _response: int

var slide_easing_param = Tween.EASE_OUT
var slide_trans_param = Tween.TRANS_BACK

var start_point: Vector2 = Vector2(0, 13)
var end_point: Vector2 = Vector2(0, -19)

var line_start: Vector2 = Vector2(0, 3)
var line_end: Vector2 = Vector2(24, 3)
var modulation_visible: Color = Color(1, 1, 1, 1)
var modulation_hidden: Color = Color(1, 1, 1, 0)
var activation_time: float = 0.6


onready var parent: Node2D = get_parent()

onready var sliding_tween: Tween = $SlidingTween
onready var visibility_tween: Tween = $VisibilityTween
onready var button_label: Label = $ButtonLabel

onready var activation_animation_tween: Tween = $ActivationAnimationTween
onready var activation_slider: ColorRect = $ActivationSlider


func _ready() -> void:
	button_label.modulate = Color(1, 1, 1, 0)
	button_label._set_position(Vector2(0, 13))
	
	activation_slider.modulate = modulation_hidden
	activation_slider._set_size(line_start)


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
	activation_slider.modulate = modulation_visible
	_response = activation_animation_tween.interpolate_property(activation_slider, "rect_size", line_start, line_end, activation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = activation_animation_tween.resume_all()
	_response = activation_animation_tween.start()


func _on_activation_stopped() -> void:
	activation_slider.modulate = modulation_hidden
	activation_slider._set_size(line_start)
	_response = activation_animation_tween.stop(activation_slider)


func _on_ActivationAnimationTween_tween_all_completed() -> void:
	parent.activate()
	activation_slider.modulate = modulation_hidden
	activation_slider._set_size(line_start)
