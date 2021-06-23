extends Node2D

var param_item: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/01_CharacterParam/ParamItem.tscn")
var perk_item: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/02_PerkItem/PerkItem.tscn")
var UI_item_hover: Resource = load("res://src/01_assets/09_Audio/s_ui/menu_hover.ogg")

var params: Dictionary = PlayerStats.stats_list
var perks: Dictionary = PlayerStats.perk_list

onready var body: Control = $CharacterSheetBody
onready var params_container: VBoxContainer = $CharacterSheetBody/StatsPanel/BottomSection/LeftSide/Params
onready var perk_container: GridContainer = $CharacterSheetBody/StatsPanel/Perks/PerkGrid
onready var description_title: Label = $CharacterSheetBody/StatsPanel/BottomSection/Description/Title
onready var description_box: RichTextLabel = $CharacterSheetBody/StatsPanel/BottomSection/Description/DescriptionBox
onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	audio_player.set_stream(Lists.char_sheet["open"])
	audio_player._set_playing(true)
	load_param_sheet()
	load_perk_grid()


func load_param_sheet() -> void:
	var param_instance
	for param in params.keys():
		param_instance = param_item.instance()
		param_instance.init(params[param].title, str(params[param].value), int(param))
		params_container.add_child(param_instance)


func load_perk_grid() -> void:
	var perk_instance
	for perk in perks.keys():
		perk_instance = perk_item.instance()
		perk_instance.init(perks[perk].perk_lvl, perks[perk].icon, int(perk))
		perk_container.add_child(perk_instance)


func _on_perk_id_received(perk_id: int) -> void:
	description_title.set_text(perks[perk_id].title)
	description_box.set_text(perks[perk_id].description)


func _on_item_id_cleared() -> void:
	description_title.set_text("")
	description_box.clear()


func _on_CloseBtn_pressed():
	get_parent().get_owner().get_parent().is_charsheet_opened = false
	close_sheet()


func close_sheet() -> void:
	audio_player.set_stream(Lists.char_sheet["close"])
	audio_player._set_playing(true)
	visible = false
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
	


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)


func _on_CloseBtn_mouse_entered() -> void:
	audio_player.set_stream(UI_item_hover)
	audio_player._set_playing(true)


func _on_CloseBtn_mouse_exited():
	pass # Replace with function body.
