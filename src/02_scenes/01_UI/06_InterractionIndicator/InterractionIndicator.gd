extends Node2D

var _response: int
var item_data: Dictionary

var modulation_visible: Color = Color(1, 1, 1, 1)
var modulation_hidden: Color = Color(1, 1, 1, 0)
var activation_time: float = 0.6


onready var parent: Node2D = get_parent().get_owner()
onready var indicator_container: Control = $InterractionIndicatorParent
onready var visibility_tween: Tween = $VisibilityTween
onready var button_label: Label = $InterractionIndicatorParent/ButtonLabel

onready var title: TextureRect = $ItemTitle
onready var label: Label = $ItemTitle/ItemLable
onready var description: TextureRect = $ItemDescription

onready var activation_animation_tween: Tween = $ActivationAnimationTween
onready var activation_texure: TextureProgress = $InterractionIndicatorParent/ActivationTexture


func _ready() -> void:
	indicator_container.modulate = Color(1, 1, 1, 0)
	title.modulate = Color(1, 1, 1, 0)
	description.modulate = Color(1, 1, 1, 0)


func _on_data_received(current_weapon: String, received_data: Dictionary) -> void:
	item_data = received_data
	label.set_text(item_data.title)
	if item_data.has("attack_power"):
		_compare_attack(Lists.weapon_list[current_weapon].attack_power, item_data.attack_power)
		_compare_speed(Lists.weapon_list[current_weapon].attack_speed, item_data.attack_speed)
		
		description.get_node("WeaponComparsion/Attack/ValCurr").set_text(str(Lists.weapon_list[current_weapon].attack_power))
		description.get_node("WeaponComparsion/Speed/ValCurr").set_text(str(Lists.weapon_list[current_weapon].attack_speed))
		description.get_node("WeaponComparsion/Attack/ValNew").set_text(str(item_data.attack_power))
		description.get_node("WeaponComparsion/Speed/ValNew").set_text(str(item_data.attack_speed))


func _compare_attack(val1: int, val2: int) -> void:
	if val1 > val2:
		description.get_node("WeaponComparsion/Attack/ValCurr").modulate = Color(0.06, 0.5, 0.25, 1)
		description.get_node("WeaponComparsion/Attack/ValNew").modulate = Color(1, 0, 0, 1)
	elif val1 < val2:
		description.get_node("WeaponComparsion/Attack/ValNew").modulate = Color(0.06, 0.5, 0.25, 1)
		description.get_node("WeaponComparsion/Attack/ValCurr").modulate = Color(1, 0, 0, 1)
	else:
		description.get_node("WeaponComparsion/Attack/ValNew").modulate = Color(0.2, 0.2, 0.2, 1)
		description.get_node("WeaponComparsion/Attack/ValCurr").modulate = Color(0.2, 0.2, 0.2, 1)


func _compare_speed(val1: int, val2: int) -> void:
	if val1 > val2:
		description.get_node("WeaponComparsion/Speed/ValCurr").modulate = Color(0.06, 0.5, 0.25, 1)
		description.get_node("WeaponComparsion/Speed/ValNew").modulate = Color(1, 0, 0, 1)
	elif val1 < val2:
		description.get_node("WeaponComparsion/Speed/ValNew").modulate = Color(0.06, 0.5, 0.25, 1)
		description.get_node("WeaponComparsion/Speed/ValCurr").modulate = Color(1, 0, 0, 1)
	else:
		description.get_node("WeaponComparsion/Speed/ValNew").modulate = Color(0.2, 0.2, 0.2, 1)
		description.get_node("WeaponComparsion/Speed/ValCurr").modulate = Color(0.2, 0.2, 0.2, 1)


func _on_indicator_enabled() -> void:
	_response = visibility_tween.interpolate_property(indicator_container, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = visibility_tween.start()
	yield(get_tree().create_timer(0.01), "timeout")
	_response = visibility_tween.interpolate_property(title, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = visibility_tween.start()
	if item_data.has("attack_power"):		
		yield(get_tree().create_timer(0.02), "timeout")
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
