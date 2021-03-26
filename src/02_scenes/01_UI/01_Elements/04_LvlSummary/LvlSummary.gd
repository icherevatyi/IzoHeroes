extends CanvasLayer

var param_item: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/01_CharacterParam/ParamItem.tscn")
var perk_item: PackedScene = preload("res://src/02_scenes/01_UI/03_Menus/02_PerkButton/PerkButton.tscn")

var is_demo_ended: bool = false
var params: Dictionary = PlayerStats.stats_list
var available_perks: Dictionary
var perk_index_list: Array = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var lvl_end_screen: VBoxContainer = $LvlEndScreen
onready var endgame_text: VBoxContainer = $EndGameText
onready var texture_bg: NinePatchRect = $BgTexture
onready var perk_container: HBoxContainer = $LvlEndScreen/PerkParent/PerkContainer
onready var perk_title: Label = $LvlEndScreen/PerkParent/DescriptionContainer/PekrDescription/PerkTitle
onready var perk_description: RichTextLabel = $LvlEndScreen/PerkParent/DescriptionContainer/PekrDescription/DescriptionBody
onready var params_container: GridContainer = $LvlEndScreen/PerkParent/DescriptionContainer/Params

func _ready() -> void:
	lvl_end_screen.visible = false
	texture_bg.visible = false
	available_perks =  PlayerStats.perk_list
	endgame_text.visible = false
	_get_perks_index()
	_assign_perks()
	load_param_sheet()


func _end_demo_reached() -> void:
	is_demo_ended = true
	endgame_text.visible = true
	lvl_end_screen.visible = false


func _input(event):
	if is_demo_ended == true:
		if event.is_pressed() == true:
			endgame_text.visible = false
			is_demo_ended = false
			Global.exit_to_menu()


func _get_perks_index() -> void:
	var perk_index: int
	while perk_index_list.size() != 3:
		perk_index = _get_random_perk()
		if perk_index_list.has(perk_index):
			perk_index = _get_random_perk()
		else:
			perk_index_list.append(perk_index)


func _on_param_id_received() -> void:
	pass


func _on_item_id_cleared() -> void:
	pass


func _assign_perks() -> void:
	var perk_index: int
	var perk: Dictionary
	for i in perk_index_list.size():
		perk_index = perk_index_list[i]
		perk = available_perks[perk_index]
		var perk_instance: TextureButton = perk_item.instance()
		perk_container.add_child(perk_instance)
		perk_instance.item_init(perk.icon, perk_index)


func load_param_sheet() -> void:
	var param_instance
	for param in params.keys():
		param_instance = param_item.instance()
		param_instance.init(params[param].title, str(params[param].value), int(param))
		params_container.add_child(param_instance)


func _on_lvl_ended() -> void:
	get_tree().paused = true
	_toggle_screen_msg()
	Global.current_lvl += 1


func _toggle_screen_msg() -> void:
	lvl_end_screen.visible = !lvl_end_screen.visible
	texture_bg.visible = !texture_bg.visible


func _get_random_perk() -> int:
	rng.randomize()
	var result: int = rng.randi_range(0, available_perks.size() - 1)
	return result


func _on_lvl_proceed() -> void:
	var _lvl_change_msg
	_toggle_screen_msg()
	if Global.current_lvl == 5:
		_lvl_change_msg = get_tree().change_scene("res://src/02_scenes/03_Locations/03_BossRooms/BossRoom.tscn")
	else:
		_lvl_change_msg = get_tree().reload_current_scene()


func _on_perk_type_received(index: int) -> void:
	perk_title.set_text(available_perks[index].title)
	perk_description.set_text(available_perks[index].description)


func _on_perk_type_cleared() -> void:
	perk_title.set_text("")
	perk_description.clear()


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
