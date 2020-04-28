extends Node

var cursor_passive = load("res://src/01_assets/01_UI/cursor_passive.png")
var cursor_active = load("res://src/01_assets/01_UI/cursor_active.png")


func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_passive, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(cursor_active, Input.CURSOR_POINTING_HAND)


func set_cursor_active() -> void:
	Input.set_custom_mouse_cursor(cursor_active)


func set_cursor_passive() -> void:
	Input.set_custom_mouse_cursor(cursor_passive)
