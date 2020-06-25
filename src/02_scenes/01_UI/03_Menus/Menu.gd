extends CanvasLayer

var menu_item: PackedScene = preload("res://src/02_scenes/01_UI/03_Menus/01_MenuItem/MenuItem.tscn")

onready var background: ColorRect = $Background
onready var items_container: VBoxContainer = $MenuBg/ItemsContainer


func _ready() -> void:
	set_pause_mode(2)
	if Global.is_game_started == false:
		background.color = Color(0, 0, 0, 1)
		_start_main_menu()
	if Global.is_game_started == true:
		background.color = Color(0, 0, 0, 0.6)
		_start_pause_menu()


func _start_main_menu() -> void:
	for item_index in Lists.main_menu_list:
		var item_instance: TextureButton = menu_item.instance()
		var item_title: String = Lists.main_menu_list[item_index].title
		var item_action = Lists.main_menu_list[item_index].action
		
		items_container.add_child(item_instance)
		item_instance.item_init(item_title, item_action)


func _start_pause_menu() ->  void:
	for item_index in Lists.pause_game_list:
		var item_instance: TextureButton = menu_item.instance()
		var item_title: String = Lists.pause_game_list[item_index].title
		var item_action = Lists.pause_game_list[item_index].action
		
		items_container.add_child(item_instance)
		item_instance.item_init(item_title, item_action)
