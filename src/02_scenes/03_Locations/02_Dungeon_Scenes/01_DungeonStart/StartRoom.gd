extends TileMap


var created: bool = false

onready var available_corridors: Dictionary = {
	"top": {
		"available": true,
		"position": $Corridors/TopCorridor.get_global_position()
	},
	"Bottom":  {
		"available": true,
		"position": $Corridors/BottomCorridor.get_global_position()
	},
	"left":  {
		"available": true,
		"position": $Corridors/LeftCorridor.get_global_position()
	},
	"right":  {
		"available": true,
		"position": $Corridors/RightCorridor.get_global_position()
	},
}

onready var dungeon: Node2D = get_node("/root/Dungeon")

signal send_available_path(path)


func _ready() -> void:
	_connect_signal("send_available_path", dungeon, "_on_corridors_received")
	add_to_group("Created")


func _on_corridors_asked(_prev_direction) -> void:
	var corridors: Dictionary = {}
	for i in available_corridors.keys():
		if available_corridors[i].available == true:
			corridors[i] = available_corridors[i]
	emit_signal("send_available_path", corridors)


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
