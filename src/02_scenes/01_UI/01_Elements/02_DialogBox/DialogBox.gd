extends Control

var dialog_type: int = 1
# Dialog box types:
# 1 - NOTIFICATION
# 2 - CONFIRMATION

onready var parent: KinematicBody2D = get_node("../../../")
onready var btn_accept: Button = $VBoxContainer/Buttons/BtnAccept
onready var btn_decline: Button = $VBoxContainer/Buttons/BtnDecline


func _ready() -> void:
	set_visible(false)
	btn_decline.visible = false
	btn_decline.get_node("LinkShadow").text = "Cancel"


func set_type(d_type: int) -> void:
	dialog_type = d_type
	match dialog_type:
		1:
			btn_accept.text = "Continue"
			btn_accept.get_node("LinkShadow").text = "Continue"
			btn_decline.visible = false
		2:
			btn_accept.text = "Yes"
			btn_accept.get_node("LinkShadow").text = "Yes"
			btn_decline.visible = true


func _on_BtnAccept_pressed() -> void:
	match dialog_type:
		2:
			parent.open_gate()
	parent.can_attack = true
	set_visible(false)


func _on_BtnDecline_pressed() -> void:
	parent.can_attack = true
	set_visible(false)


func _on_DialogBox_mouse_entered() -> void:
	parent.can_attack = false


func _on_DialogBox_mouse_exited() -> void:
	parent.can_attack = true


func _on_BtnAccept_mouse_entered() -> void:
	parent.can_attack = false


func _on_BtnAccept_mouse_exited() -> void:
	parent.can_attack = true


func _on_BtnDecline_mouse_entered() -> void:
	parent.can_attack = false


func _on_BtnDecline_mouse_exited() -> void:
	parent.can_attack = true
