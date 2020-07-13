extends CanvasLayer

var perk_item: PackedScene = preload("res://src/02_scenes/01_UI/03_Menus/02_PerkButton/PerkButton.tscn")

var available_perks: Dictionary
var perk_index_list: Array = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var textarea: RichTextLabel = $RichTextLabel
onready var lvl_end_screen: VBoxContainer = $LvlEndScreen
onready var perk_container: HBoxContainer = $LvlEndScreen/PerkContainer
onready var perk_description: RichTextLabel = $LvlEndScreen/PekrDescription/DescriptionBody
onready var button_label: Label = $LvlEndScreen/Button/Label

func _ready() -> void:
	lvl_end_screen.visible = false
	available_perks =  PlayerParams.perk_list
	_get_perks_index()
	_assign_perks()


func _end_demo_reached(message: String) -> void:
	print("signal received")
	textarea.bbcode_enabled = true
	var formatted_text = "[color=white][center]" + message + "[/center][/color]"
	textarea.set_bbcode(formatted_text)


func _get_perks_index() -> void:
	var perk_index: int
	while perk_index_list.size() != 3:
		perk_index = _get_random_perk()
		if perk_index_list.has(perk_index):
			perk_index = _get_random_perk()
		else:
			perk_index_list.append(perk_index)


func _assign_perks() -> void:
	var perk_index: int
	var perk: Dictionary
	print(perk_index_list.size(), " - list_size")
	print(perk_index_list, " - list itself")
	for i in perk_index_list.size():
		print(i, " - index")
		perk_index = perk_index_list[i]
		print(perk_index)
		perk = available_perks[perk_index]
		var perk_instance: Control = perk_item.instance()
		perk_container.add_child(perk_instance)
		perk_instance.item_init(perk.title, perk_index)
		


func _on_lvl_ended() -> void:
	_toggle_screen_msg()
	Global.current_lvl += 1


func _toggle_screen_msg() -> void:
	lvl_end_screen.visible = !lvl_end_screen.visible


func _get_random_perk() -> int:
	rng.randomize()
	var result: int = rng.randi_range(1, available_perks.size())
	return result


func _on_TextureButton_button_down() -> void:
	button_label.set_position(Vector2(160, 6))


func _on_TextureButton_button_up() -> void:
	_toggle_screen_msg()
	var _lvl_change_msg = get_tree().reload_current_scene()
	button_label.set_position(Vector2(160, 3))


func _on_perk_type_received(index: int) -> void:
	perk_description.set_text(available_perks[index].description)


func _on_perk_type_cleared() -> void:
	perk_description.clear()


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
