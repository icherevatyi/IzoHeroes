extends Control

var param_scene: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/01_CharacterParam/ParamItem.tscn")

var params: Dictionary = PlayerParams.param_list
var perks: Dictionary = PlayerParams.perk_list

onready var params_container: VBoxContainer = $SheetConainer/StatsPanel/Params

#signal connect_perk()


func _ready() -> void:
	load_param_sheet()


func load_param_sheet() -> void:
	var param_instance
	for param in params.keys():
		param_instance = param_scene.instance()
		param_instance.init(params[param].title, params[param].value)
		params_container.add_child(param_instance)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
