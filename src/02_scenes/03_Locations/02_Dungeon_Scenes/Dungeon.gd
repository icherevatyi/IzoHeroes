extends Node2D

var starting_position: Vector2 = Vector2(0, 0)

onready var background: CanvasLayer = $Background

func _ready() -> void:
	Backdrop.fade_out()
	spawn_room("START_ROOM", starting_position)


func spawn_room(room_type, room_pos) -> void:
	var room_instance
	match room_type:
		"START_ROOM":
			room_instance = Lists.start_room[1].instance()
		"BOTTOM_ROOM":
			room_instance = Lists.bottom_room[1].instance()
	room_instance.set_global_position(starting_position)
	self.add_child_below_node(background, room_instance)
	if room_instance.is_in_group("TOP_EXIT"):
		spawn_room("BOTTOM_ROOM", room_instance.get_node("TopExit"))
