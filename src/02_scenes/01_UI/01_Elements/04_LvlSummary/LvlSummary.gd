extends CanvasLayer

onready var textarea: RichTextLabel = $RichTextLabel


func _end_demo_reached(message: String) -> void:
	print("signal received")
	textarea.bbcode_enabled = true
	var formatted_text = "[color=white][center]" + message + "[/center][/color]"
	textarea.set_bbcode(formatted_text)
