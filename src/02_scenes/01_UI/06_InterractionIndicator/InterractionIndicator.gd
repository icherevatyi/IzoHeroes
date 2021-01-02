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
onready var effect_container: HBoxContainer = $ItemDescription/WeaponComparsion/Effect

func _ready() -> void:
	indicator_container.modulate = Color(1, 1, 1, 0)
	title.modulate = Color(1, 1, 1, 0)
	description.modulate = Color(1, 1, 1, 0)


func _on_data_received(received_data: Dictionary = Lists.weapon_list["steel_sword"], current_weapon: String = "steel_sword") -> void:
	item_data = received_data
	label.set_text(item_data.title)
	if item_data.has("attack_power"):
		_compare_values(Lists.weapon_list[current_weapon].attack_power, item_data.attack_power, "Attack")
		_compare_values(Lists.weapon_list[current_weapon].attack_speed, item_data.attack_speed, "Speed")
		_compare_values(Lists.weapon_list[current_weapon].stamina_usage, item_data.stamina_usage, "Stam")
		_compare_values(Lists.weapon_list[current_weapon].crit_mult, item_data.crit_mult, "Crit")
		
		description.get_node("WeaponComparsion/Attack/ValCurr").set_text(str(Lists.weapon_list[current_weapon].attack_power))
		description.get_node("WeaponComparsion/Speed/ValCurr").set_text(str(Lists.weapon_list[current_weapon].attack_speed))
		description.get_node("WeaponComparsion/Stam/ValCurr").set_text(str(Lists.weapon_list[current_weapon].stamina_usage))
		description.get_node("WeaponComparsion/Crit/ValCurr").set_text(str(Lists.weapon_list[current_weapon].crit_mult))
		description.get_node("WeaponComparsion/Attack/ValNew").set_text(str(item_data.attack_power))
		description.get_node("WeaponComparsion/Speed/ValNew").set_text(str(item_data.attack_speed))
		description.get_node("WeaponComparsion/Stam/ValNew").set_text(str(item_data.stamina_usage))
		description.get_node("WeaponComparsion/Crit/ValNew").set_text(str(item_data.crit_mult))


func _compare_values(val1: float, val2: float, Param: String) -> void:
	if val1 > val2:
		description.get_node("WeaponComparsion/" + Param + "/ValCurr").modulate = Color(0.06, 0.5, 0.25, 1)
		description.get_node("WeaponComparsion/" + Param + "/ValNew").modulate = Color(0.72, 0.23, 0.23, 1)
		if Param == "Stam":
			description.get_node("WeaponComparsion/" + Param + "/ValNew").modulate = Color(0.06, 0.5, 0.25, 1)
			description.get_node("WeaponComparsion/" + Param + "/ValCurr").modulate = Color(0.72, 0.23, 0.23, 1)
	elif val1 < val2:
		description.get_node("WeaponComparsion/" + Param + "/ValNew").modulate = Color(0.06, 0.5, 0.25, 1)
		description.get_node("WeaponComparsion/" + Param + "/ValCurr").modulate = Color(0.72, 0.23, 0.23, 1)
		if Param == "Stam":
			description.get_node("WeaponComparsion/" + Param + "/ValNew").modulate = Color(0.72, 0.23, 0.23, 1)
			description.get_node("WeaponComparsion/" + Param + "/ValCurr").modulate = Color(0.06, 0.5, 0.25, 1)
	else:
		description.get_node("WeaponComparsion/" + Param + "/ValNew").modulate = Color(0.2, 0.2, 0.2, 1)
		description.get_node("WeaponComparsion/" + Param + "/ValCurr").modulate = Color(0.2, 0.2, 0.2, 1)


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
		if item_data.type == "blood_falchion":
			description._set_size(Vector2(66, 54))
			description.get_node("WeaponComparsion/Effect").visible = true


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
