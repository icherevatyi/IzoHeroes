extends Node2D

var stored_items: Dictionary = {
	1: {
		"loot_item_type": "gold_coins",
		"amount": 0,
	},
	2: {
		"loot_item_type": "healing_bottle",
		"amount": 0,
	}
}

onready var HUD: CanvasLayer = get_node("../../HUD")

signal pick_item
signal _on_pickup_HUD_update(type, value)


func  _ready() -> void:
	_connect_signal("_on_pickup_HUD_update", HUD, "_on_item_picked_up")


func _on_PickupDetectionRange_body_entered(body) -> void:
	if body.is_in_group("loot"):
		_connect_signal("pick_item", body, "_on_item_picked_up")
		emit_signal("pick_item")


func process_received_loot_data(data) -> void:
	for index in stored_items:
		if stored_items[index].loot_item_type == data.item_type:
			stored_items[index].amount += data.amount
			
			emit_signal("_on_pickup_HUD_update", stored_items[index].loot_item_type, stored_items[index].amount)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
