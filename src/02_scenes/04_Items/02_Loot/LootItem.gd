extends RigidBody2D

var item_info: Dictionary

var item_local_data: Dictionary = {
	"item_type": "item",
	"amount": 0
}

var direction_list: Dictionary = {
	0: Vector2(0, -150),
	1: Vector2(0, 150),
	2: Vector2(150, 0),
	3: Vector2(-150, 0)
}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var info_trigger_area: Area2D = $InfoTriggerArea

signal transfer_item_data(data)


func _ready() -> void:
	item_local_data.item_type = item_info.type
	_generate_item_amount()
	apply_central_impulse(_select_direction())


func _on_Timer_timeout():
	sleeping = true
	set_collision_layer_bit(3, true)


func _generate_item_amount() -> void:
	if item_info.max_value != 1:
		rng.randomize()
		var randomized_value = rng.randi_range(item_info.min_value, item_info.max_value)
		item_local_data.amount = randomized_value
	else:
		item_local_data.amount = item_info.max_value


func _select_direction() -> Vector2:
	rng.randomize()
	var rand_dir = rng.randi_range(0, 3)
	return direction_list[rand_dir]


func _on_item_picked_up() -> void:
	queue_free()


func _on_InfoTriggerArea_area_entered(area):
	if area.name == "PickupDetectionRange":
		var player = area.get_parent()
		_connect_signal("transfer_item_data", player, "_on_item_data_received")
		emit_signal("transfer_item_data", item_local_data)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)

