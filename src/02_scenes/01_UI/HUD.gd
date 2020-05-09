extends CanvasLayer

var heart_point: PackedScene = preload("res://src/02_scenes/01_UI/01_Elements/01_PlayerHealthIcon/Heart.tscn")

onready var healthbar: HBoxContainer = $Control/HealthBar
onready var dialog_box: PopupPanel = $Control/DialogBox
onready var gold_coins_counter: HBoxContainer = $Control/Coins/Count
onready var healing_bottle_counter: HBoxContainer = $Control/PlayerStoredPotions/Count

var bottle_amount: int

func _ready() -> void:
	_on_healing_displayed(ResourceStorage.player_data.health_current)
	_on_item_picked_up("gold_coins", ResourceStorage.player_data.coins_count)
	_on_item_picked_up("healing_bottle", ResourceStorage.player_data.healing_pots_count)


func _on_message_shown(msg) -> void:
	var textarea: RichTextLabel = dialog_box.get_node("TextArea")
	textarea.set_text(msg)
	dialog_box.popup()


func _on_message_hidden() -> void:
	var textarea: RichTextLabel = dialog_box.get_node("TextArea")
	textarea.clear()
	dialog_box.visible = false


func _on_healing_displayed(amount: int) -> void:
	for healthpoint in amount:
		var _h_instance = heart_point.instance()
		healthbar.add_child(_h_instance)


func _on_damage_displayed(dmg_taken: int) -> void:
	var _health_pool = healthbar.get_children()
	if _health_pool.size() >= dmg_taken:
		for health_point in dmg_taken:
			_health_pool[health_point].queue_free()
	else:
		dmg_taken = _health_pool.size()
		_on_damage_displayed(dmg_taken)


func _on_item_picked_up(type, value):
	if type == "gold_coins":
		gold_coins_counter.set_text("x " + str(value))
	if type == "healing_bottle":
		bottle_amount = value
		healing_bottle_counter.text = "x " + str(bottle_amount)


func _on_bottle_used() -> void:
	bottle_amount -= 1
	healing_bottle_counter.text = "x " + str(bottle_amount)
