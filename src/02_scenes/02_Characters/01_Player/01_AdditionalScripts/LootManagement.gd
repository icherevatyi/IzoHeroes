extends Node2D

var gold_coins: int
var healing_bottle: int
var has_key: bool = false

onready var HUD: CanvasLayer = get_node("../../HUD")

signal pick_item
signal _on_pickup_HUD_update(type, value)


func  _ready() -> void:
	gold_coins = ResourceStorage.player_data.coins_count
	healing_bottle = ResourceStorage.player_data.healing_pots_count
	_connect_signal("_on_pickup_HUD_update", HUD, "_on_item_picked_up")


func _on_PickupDetectionRange_area_entered(area):
	if area.get_parent().is_in_group("loot"):
		_connect_signal("pick_item", area.get_parent(), "_on_item_picked_up")
		emit_signal("pick_item")


func process_received_loot_data(data) -> void:
	match data.item_type:
		"gold_coins":
			gold_coins +=data.amount
			emit_signal("_on_pickup_HUD_update", "gold_coins", data.amount)
		"healing_bottle":
			healing_bottle +=data.amount
			emit_signal("_on_pickup_HUD_update", "healing_bottle", data.amount)
		"key":
			has_key = true
			emit_signal("_on_pickup_HUD_update", "key", 1)


func _on_bottle_used() -> void:
	healing_bottle -= 1


func _on_key_used() -> void:
	has_key = false


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
