extends CanvasLayer

var rng := RandomNumberGenerator.new()
var notification_message: PackedScene = preload("res://src/02_scenes/01_UI/01_Elements/Notification/PickupNotification.tscn")
var char_sheet: PackedScene = preload("res://src/02_scenes/01_UI/05_CharacterSheet/CharacterSheet.tscn")
var _response: int
var is_stat_screen_shown: bool = false
var shake_offset_value: float = 0

var coins_amount: int
var bottle_amount: int

onready var player: KinematicBody2D = get_node("../")
onready var ui_parent: Control = $Control
onready var notification_container: VBoxContainer = $Control/NotificationContainer
onready var health_top:  = $Control/Health/HealthBarTop
onready var health_bottom:  = $Control/Health/HealthBarBottom
onready var stamina_top: = $Control/Stamina/StaminaBarTop
onready var stamina_bottom: = $Control/Stamina/StaminaBarBottom 
onready var dialog_box: Control = $Control/DialogBox
onready var healing_bottle_counter: Label = $Control/PlayerStoredPotions/Count
onready var coin_icon: TextureRect = $Control/Coins/CoinIcons
onready var bottle_icon: TextureRect = $Control/PlayerStoredPotions/PotionsIcon
onready var hud_change_tween: Tween = $HUDTween
onready var hp_change_tween: Tween = $HPChangeTween
onready var stamina_change_tween: Tween = $StaminaChangeTween
onready var bottle_shake_tween: Tween = $BottleShakeTween
onready var coin_shake_tween: Tween = $CoinShakeTween
onready var coin_frequency_timer: Timer = $Timers/CoinFrequencyTimer
onready var coin_duration_timer: Timer = $Timers/CoinDurationTimer
onready var bottle_frequency_timer: Timer = $Timers/BottleFrequencyTimer
onready var bottle_duration_timer: Timer = $Timers/BottleDurationTimer
onready var key_item: TextureRect = $Control/KeyItem
onready var player_message_popup: Label = $Control/PlayerMessagePopup
onready var popup_fade_tween: Tween = $PopupFadeTween
onready var popup_timer: Timer = $Timers/PopupTimer
onready var vamp_icon: TextureRect = $Control/VampiricIcon
onready var floor_number: Label = $Control/Floor

func _ready() -> void:
	health_top.max_value = ResourceStorage.player_data.health_current
	health_top.value = ResourceStorage.player_data.health_current
	health_bottom.max_value = ResourceStorage.player_data.health_current
	health_bottom.value = ResourceStorage.player_data.health_current
	
	stamina_top.max_value = PlayerStats.stats_list[1].value
	stamina_top.value = PlayerStats.stats_list[1].value
	stamina_bottom.max_value = PlayerStats.stats_list[1].value
	stamina_bottom.value = PlayerStats.stats_list[1].value
	
	_display_starting_amount("gold_coins", ResourceStorage.player_data.coins_count)
	_display_starting_amount("healing_bottle", ResourceStorage.player_data.healing_pots_count)
	manage_buff_icon()
	floor_number.set_text("Floor " + str(Global.current_lvl))


func toggle_char_sheet() -> void:
	if ui_parent.has_node("CharacterSheet"):
		ui_parent.get_node("CharacterSheet").close_sheet()
	else:
		ui_parent.add_child(char_sheet.instance())


func manage_buff_icon(value: bool = false) -> void:
	match value:
		true:
			vamp_icon.set_visible(true)
		false:
			vamp_icon.set_visible(false)


func notify_pickup(item, amount) -> void:
	var notif_instance = notification_message.instance()
	notification_container.add_child(notif_instance)
	notif_instance.set_scale(Vector2(0.4, 0.4))
	notif_instance.text = "Picked up " + str(amount) + " " + item + "!"


func _on_message_shown(msg, dialog_type) -> void:
	var textarea: RichTextLabel = dialog_box.get_node("VBoxContainer/TextArea")
	textarea.set_text(msg)
	dialog_box.visible = true
	dialog_box.set_type(dialog_type)


func _on_message_hidden() -> void:
	var textarea: RichTextLabel = dialog_box.get_node("VBoxContainer/TextArea")
	textarea.clear()
	dialog_box.visible = false
	player.can_attack = true


func _on_healing_displayed(amount: int) -> void:
	var health_current = health_top.value
	var health_new = health_current + amount
	_response = hp_change_tween.interpolate_property(health_top, "value", health_current, health_new, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_change_tween.start()
	_response = hp_change_tween.interpolate_property(health_top, "value", health_current, health_new, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_change_tween.start()


func _on_damage_displayed(dmg_taken: int) -> void:
	var health_current = health_top.value
	var health_new = health_current - dmg_taken
	health_top.value = health_new
	_response = hp_change_tween.interpolate_property(health_bottom, "value", health_current, health_new - dmg_taken, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = hp_change_tween.start()


func _on_stamina_used(value) -> void:
	var stam_current = stamina_top.value
	var stam_new = stam_current - value
	stamina_top.value = stam_new
	_response = stamina_change_tween.interpolate_property(stamina_bottom, "value", stam_current, stam_new - value, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_response = stamina_change_tween.start()


func _on_stam_regenerated(regen_amount) -> void:
	stamina_top.value = stamina_top.value + regen_amount


func _display_starting_amount(type, value) -> void:
	if type == "healing_bottle":
		bottle_amount += value
		healing_bottle_counter.text = "x " + str(bottle_amount)


func _on_item_picked_up(type, value) -> void:
	if type == "healing_bottle":
		_start_bottle_shake()
		bottle_amount += value
		healing_bottle_counter.text = "x " + str(bottle_amount)
	if type == "key":
		key_item.visible = true
	var item_name	
	if Lists.loot_list.has(type):
		item_name = Lists.loot_list[type].title
	else:
		item_name = Lists.boss_loot_list[type].title
	notify_pickup(item_name, value)


func _start_coins_shake() -> void:
	shake_offset_value = 5
	coin_duration_timer.wait_time = 0.2
	coin_frequency_timer.wait_time = 1 / float(30)
	coin_duration_timer.start()
	coin_frequency_timer.start()
	
	_shake_coins_icon()


func _start_bottle_shake() -> void:
	shake_offset_value = 5
	bottle_duration_timer.wait_time = 0.2
	bottle_frequency_timer.wait_time = 1 / float(30)
	bottle_duration_timer.start()
	bottle_frequency_timer.start()
	
	_shake_bottle_icon()


func _shake_coins_icon() -> void:
	var rand_position = Vector2()
	rng.randomize()
	rand_position.x = rng.randf_range(-shake_offset_value, shake_offset_value)
	rand_position.y = rng.randf_range(-shake_offset_value, shake_offset_value)
	
	_response = coin_shake_tween.interpolate_property(coin_icon, "rect_position", Vector2(0, 0), rand_position, coin_frequency_timer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_response = coin_shake_tween.start()


func _shake_bottle_icon() -> void:
	var rand_position = Vector2()
	rng.randomize()
	rand_position.x = rng.randf_range(-shake_offset_value, shake_offset_value)
	rand_position.y = rng.randf_range(-shake_offset_value, shake_offset_value)
	
	_response = bottle_shake_tween.interpolate_property(bottle_icon, "rect_position", offset, rand_position, bottle_frequency_timer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_response = bottle_shake_tween.start()


func _on_CoinFrequencyTimer_timeout() -> void:
	_shake_coins_icon()


func _on_BottleFrequencyTimer_timeout() -> void:
	_shake_bottle_icon()

func _on_CoinDurationTimer_timeout() -> void:
	_reset_coin_position()
	coin_frequency_timer.stop()


func _on_BottleDurationTimer_timeout() -> void:
	_reset_bottle_position()
	bottle_frequency_timer.stop()


func _reset_coin_position() ->  void:
	_response = coin_shake_tween.interpolate_property(coin_icon, "rect_position", offset, Vector2(), coin_frequency_timer.wait_time, coin_shake_tween.TRANS_SINE, coin_shake_tween.EASE_IN_OUT)


func _reset_bottle_position() -> void:
	_response = bottle_shake_tween.interpolate_property(bottle_icon, "rect_position", offset, Vector2(), bottle_frequency_timer.wait_time, bottle_shake_tween.TRANS_SINE, bottle_shake_tween.EASE_IN_OUT)


func _on_bottle_used() -> void:
	bottle_amount -= 1
	healing_bottle_counter.text = "x " + str(bottle_amount)


func _on_key_received() -> void:
	key_item.visible = true


func _on_key_used() -> void:
	key_item.visible = false


func on_exhaustion_message_trigger() -> void:
	player_message_popup.text = get_tired_phrase()
	_response = popup_fade_tween.interpolate_property(player_message_popup, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1),  1, popup_fade_tween.TRANS_LINEAR, popup_fade_tween.EASE_IN_OUT)
	_response = popup_fade_tween.start()
	popup_timer.set_wait_time(1)
	popup_timer.start()


func on_player_msg_triggered(msg, time) -> void:
	player_message_popup.text = msg
	_response = popup_fade_tween.interpolate_property(player_message_popup, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1),  time, popup_fade_tween.TRANS_QUINT, popup_fade_tween.EASE_OUT)
	_response = popup_fade_tween.start()
	popup_timer.set_wait_time(time)
	popup_timer.start()


func get_tired_phrase() ->  String:
	rng.randomize()
	var phrase_number = rng.randi_range(0, Lists.exhaustion_messages.size() - 1)
	return Lists.exhaustion_messages[phrase_number]


func _on_PopupTimer_timeout() -> void:
	_response = popup_fade_tween.interpolate_property(player_message_popup, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0),  1, popup_fade_tween.TRANS_LINEAR, popup_fade_tween.EASE_IN_OUT)
	_response = popup_fade_tween.start()


func hide_HUD() -> void:
	_response = hud_change_tween.interpolate_property(ui_parent, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.EASE_IN_OUT, Tween.TRANS_LINEAR)
	_response = hud_change_tween.start()


func _on_music_started(author) -> void:
	$MusicAuthorNotifier._on_author_name_received(author)
