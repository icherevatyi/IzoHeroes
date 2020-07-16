extends CanvasLayer

var param_scene: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/01_CharacterParam/ParamItem.tscn")
var perk_scene: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/02_PerkItem/PerkItem.tscn")


var params: Dictionary = PlayerStats.stats_list
var perks: Dictionary = PlayerStats.perk_list

onready var body: Control = $CharacterSheetBody
onready var params_container: VBoxContainer = $CharacterSheetBody/StatsPanel/BottomSection/LeftSide/Params
onready var perk_container: GridContainer = $CharacterSheetBody/StatsPanel/Perks/PerkGrid
onready var description_box: RichTextLabel = $CharacterSheetBody/StatsPanel/BottomSection/Description/DescriptionBox

func _ready() -> void:
	body.set_visible(false)
	load_param_sheet()
	load_perk_grid()


func _clear_children(node_var) -> bool:
	for child in node_var.get_children():
		child.queue_free()
	if node_var.get_children().size() == 0:
		return true
	else:
		return false


func load_param_sheet() -> void:
	var _response_value = _clear_children(params_container)
	var param_instance
	for param in params.keys():
		param_instance = param_scene.instance()
		param_instance.init(params[param].title, str(params[param].value), int(param))
		params_container.add_child(param_instance)


func load_perk_grid() -> void:
	var _response_value = _clear_children(perk_container)
	var perk_instance
	for perk in perks.keys():
		perk_instance = perk_scene.instance()
		perk_instance.init(perks[perk].title, perks[perk].perk_lvl, int(perk))
		perk_container.add_child(perk_instance)


func _on_perk_id_received(perk_id: int) -> void:
	description_box.set_text(perks[perk_id].description)
	
	
func _on_param_id_received(param_id: int) -> void:
	description_box.set_text(params[param_id].description)


func _on_item_id_cleared() -> void:
	description_box.clear()


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
