extends Control

onready var popup_container: PopupPanel = $Popup
onready var textarea: RichTextLabel = $Popup/RichTextLabel


func _on_message_received(message) -> void:
	popup_container.popup()
	textarea.set_text(message)
