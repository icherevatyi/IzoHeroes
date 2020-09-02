extends Camera2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var offset_value: float = 0
var _return_v 

onready var tween: Tween = $Tween
onready var frequency_timer: Timer = $FrequencyTimer
onready var duration_timer: Timer = $DurationTimer



func start_shaking( duration = 0.2, frequency = 15, off_value = 16):
	self.offset_value = off_value
	duration_timer.wait_time = duration
	frequency_timer.wait_time = 1 / float(frequency)
	duration_timer.start()
	frequency_timer.start()
	
	_shake_screen()


func _shake_screen() -> void:
	var rand_offset = Vector2()
	rng.randomize()
	rand_offset.x = rng.randf_range(-offset_value, offset_value)
	rand_offset.y = rng.randf_range(-offset_value, offset_value)
	
	_return_v = tween.interpolate_property(self, "offset", offset, rand_offset, frequency_timer.wait_time, tween.TRANS_SINE, tween.EASE_IN_OUT)
	_return_v = tween.start()


func _on_FrequencyTimer_timeout() -> void:
	_shake_screen()


func _reset_position() -> void:
	_return_v = tween.interpolate_property(self, "offset", offset, Vector2(), frequency_timer.wait_time, tween.TRANS_SINE, tween.EASE_IN_OUT)


func _on_DurationTimer_timeout() -> void:
	_reset_position()
	frequency_timer.stop()
