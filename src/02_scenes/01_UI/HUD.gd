extends CanvasLayer

var heart_point: PackedScene = preload("res://src/02_scenes/01_UI/01_Elements/01_PlayerHealthIcon/Heart.tscn")

onready var healthbar: HBoxContainer = $Control/HealthBar
onready var dialog_box: PopupPanel = $Control/DialogBox


func _ready() -> void:
	_on_healing_displayed(ResourceStorage.player_data.health_current)


func _on_message_shown(msg) -> void:
	var textarea: RichTextLabel = dialog_box.get_node("TextArea")
	textarea.set_text(msg)
	dialog_box.popup()


func _on_message_hidden() -> void:
	var textarea: RichTextLabel = dialog_box.get_node("TextArea")
	textarea.clear()
	dialog_box.visible = false


func _on_healing_displayed(amount: int) -> void:
	for healthpoint in amount:
		var _h_instance = heart_point.instance()
		healthbar.add_child(_h_instance)


func _on_damage_displayed(dmg_taken: int) -> void:
	var _health_pool = healthbar.get_children()
	if _health_pool.size() >= dmg_taken:
		for health_point in dmg_taken:
			_health_pool[health_point].queue_free()
	else:
		dmg_taken = _health_pool.size()
		_on_damage_displayed(dmg_taken)
