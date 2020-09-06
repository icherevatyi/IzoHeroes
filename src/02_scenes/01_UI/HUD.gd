extends CanvasLayer

var notification_message: PackedScene = preload("res://src/02_scenes/01_UI/01_Elements/Notification/PickupNotification.tscn")
var char_sheet: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/CharacterSheet.tscn")
var _response: int
var is_stat_screen_shown: bool = false

onready var player: KinematicBody2D = get_node("../")
onready var ui_parent: Control = $Control
onready var notification_container: VBoxContainer = $Control/NotificationContainer
onready var health_top:  = $Control/Health/HealthBarTop
onready var health_bottom:  = $Control/Health/HealthBarBottom
onready var dialog_box: Control = $Control/DialogBox
onready var gold_coins_counter: HBoxContainer = $Control/Coins/Count
onready var healing_bottle_counter: HBoxContainer = $Control/PlayerStoredPotions/Count
onready var hp_change_tween: Tween = $HPChangeTween
onready var key_item: TextureRect = $Control/KeyItem

var coins_amount: int
var bottle_amount: int

func _ready() -> void:
	health_top.max_value = ResourceStorage.player_data.health_current
	health_top.value = ResourceStorage.player_data.health_current
	health_bottom.max_value = ResourceStorage.player_data.health_current
	health_bottom.value = ResourceStorage.player_data.health_current
	
	_display_starting_amount("gold_coins", ResourceStorage.player_data.coins_count)
	_display_starting_amount("healing_bottle", ResourceStorage.player_data.healing_pots_count)


func toggle_char_sheet() -> void:
	if ui_parent.has_node("CharacterSheet"):
		ui_parent.get_node("CharacterSheet").queue_free()
	else:
		ui_parent.add_child(char_sheet.instance())


func notify_pickup(item, amount) -> void:
	var notif_instance = notification_message.instance()
	notification_container.add_child(notif_instance)
	notif_instance.set_scale(Vector2(0.4, 0.4))
	notif_instance.text = "Picked up " + str(amount) + " " + item + "!"


func _on_message_shown(msg, dialog_type) -> void:
	var textarea: RichTextLabel = dialog_box.get_node("VBoxContainer/TextArea")
	textarea.set_text(msg)
	dialog_box.visible = true
	dialog_box.set_type(dialog_type)


func _on_message_hidden() -> void:
	var textarea: RichTextLabel = dialog_box.get_node("VBoxContainer/TextArea")
	textarea.clear()
	dialog_box.visible = false
	player.can_attack = true


func _on_healing_displayed(amount: int) -> void:
	var health_current = health_top.value
	var health_new = health_current + amount
	_response = hp_change_tween.interpolate_property(health_top, "value", health_current, health_new, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_change_tween.start()
	_response = hp_change_tween.interpolate_property(health_top, "value", health_current, health_new, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_change_tween.start()


func _on_damage_displayed(dmg_taken: int) -> void:
	var health_current = health_top.value
	var health_new = health_current - dmg_taken
	health_top.value = health_new
	_response = hp_change_tween.interpolate_property(health_bottom, "value", health_current, health_new - dmg_taken, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_change_tween.start()


func _display_starting_amount(type, value) -> void:
	if type == "gold_coins":
		coins_amount += value
		gold_coins_counter.set_text("x " + str(coins_amount))
	if type == "healing_bottle":
		bottle_amount += value
		healing_bottle_counter.text = "x " + str(bottle_amount)
	

func _on_item_picked_up(type, value) -> void:
	if type == "gold_coins":
		coins_amount += value
		gold_coins_counter.set_text("x " + str(coins_amount))
	if type == "healing_bottle":
		bottle_amount += value
		healing_bottle_counter.text = "x " + str(bottle_amount)
	if type == "key":
		key_item.visible = true
	var item_name	
	if Lists.loot_list.has(type):
		item_name = Lists.loot_list[type].title
	else:
		item_name = Lists.boss_loot_list[type].title
	notify_pickup(item_name, value)


func _on_bottle_used() -> void:
	bottle_amount -= 1
	healing_bottle_counter.text = "x " + str(bottle_amount)


func _on_key_received() -> void:
	key_item.visible = true


func _on_key_used() -> void:
	key_item.visible = false
