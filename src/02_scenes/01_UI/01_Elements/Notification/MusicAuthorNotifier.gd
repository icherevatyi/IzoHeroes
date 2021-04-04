extends Control

var _return_val: int

onready var author_name: Label = $AuthorName
onready var tween: Tween = $Tween


func _on_author_name_received(name) -> void:
	author_name.set_text(name)
	$Timer.set_wait_time(1)
	$Timer.start()


func _show_author() ->  void:
	_return_val = tween.interpolate_property(author_name, "rect_position", Vector2(0, 34), Vector2(0, 16), 0.7, Tween.TRANS_BACK, Tween.EASE_OUT)
	_return_val = tween.start()
	$Timer.set_wait_time(4)
	$Timer.start()


func _hide_author() ->  void:
	_return_val = tween.interpolate_property(author_name, "rect_position", Vector2(0, 16), Vector2(0, 34), 0.7, Tween.TRANS_BACK, Tween.EASE_IN)
	_return_val =tween.start()


func _on_Timer_timeout():
	if $Timer.get_wait_time() == 1:
		_show_author()
	else: 
		_hide_author()
