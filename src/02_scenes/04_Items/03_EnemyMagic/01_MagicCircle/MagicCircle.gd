extends Area2D

var damage: int

signal attack(dmg)
signal stagger

func _ready():
	$AnimationPlayer.play("create")


func _destroy_circle() ->  void:
	queue_free()


func _on_MagicCircle_area_entered(area):
	if area.name == "HurtBox":
		_connect_signal("attack", area.get_parent(), "_damage_taken")
		_connect_signal("stagger", area.get_parent(), "_player_staggered")
		emit_signal("attack", damage)
		emit_signal("stagger")


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)
