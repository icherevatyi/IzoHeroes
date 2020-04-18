extends KinematicBody2D

export var speed: int = 120
var movement: Vector2 = Vector2(0, 0)


func _ready() -> void:
	pass

func _physics_process(_delta) -> void:
	_move_player()

func _move_player() ->  void:
	movement.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movement.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	movement = movement * speed
	movement = move_and_slide(movement, Vector2(0, 0))


func _input(event):
	if event.is_action_pressed("move_left"):
		$Sprite.flip_h = true
	if event.is_action_pressed("move_right"):
		$Sprite.flip_h = false


func _on_message_received(msg: String) -> void:
	print(msg)
