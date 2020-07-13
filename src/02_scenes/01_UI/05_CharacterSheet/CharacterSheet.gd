extends Control

var param_scene: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/01_CharacterParam/ParamItem.tscn")
var perk_scene: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/02_PerkItem/PerkItem.tscn")


var params: Dictionary = PlayerParams.param_list
var perks: Dictionary = PlayerParams.perk_list

onready var params_container: VBoxContainer = $StatsPanel/BottomSection/Params
onready var perk_container: GridContainer = $StatsPanel/Perks/PerkGrid


func _ready() -> void:
	load_param_sheet()
	load_perk_grid()


func load_param_sheet() -> void:
	var param_instance
	for param in params.keys():
		param_instance = param_scene.instance()
		param_instance.init(params[param].title, params[param].value)
		params_container.add_child(param_instance)


func load_perk_grid() -> void:
	var perk_instance
	for perk in perks.keys():
		perk_instance = perk_scene.instance()
		perk_instance.init(perks[perk].title, perks[perk].perk_lvl)
		perk_container.add_child(perk_instance)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
