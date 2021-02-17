extends Area2D

var projectile_noize_sound: Resource = load("res://src/01_assets/09_Audio/s_enemies/projectileNoize.ogg")
var expulosion_sound: Resource = load("res://src/01_assets/09_Audio/s_enemies/expulosion.ogg")

var is_flipped: bool = false
var damage: int
var speed: int = 250

onready var audio_player: AudioStreamPlayer2D = $ProjectileAudio

signal do_damage(damage)

func _ready() -> void:
	audio_player.set_stream(projectile_noize_sound)
	audio_player._set_playing(true)
	
	match is_flipped:
		false:
			$Sprite.flip_v = false
		true:
			$Sprite.flip_v = true


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_MagicSkull_body_entered(body) -> void:
	if body.name == "Player":
		_connect_signal("do_damage", body, "_damage_taken")
		emit_signal("do_damage", damage)
		disconnect("do_damage", body, "_damage_taken")
		_explode()
	if body.is_in_group("rooms"):
		_explode()


func _explode() ->  void:
	$Sprite.play("explosion")
	audio_player.set_stream(expulosion_sound)
	audio_player._set_playing(true)
	speed = 0
	$Trail.emitting = false


func _connect_signal(signal_title: String, target_node, target_function_title: String) -> void:
	match is_connected(signal_title, target_node, target_function_title):
		false:
			var connection_msg: int = connect(signal_title, target_node, target_function_title)
			if connection_msg == 0:
				return
			else:
				print("Signal connection error: ", connection_msg)



func _on_Sprite_animation_finished():
	$Sprite.playing = false
	if $Sprite.animation == "explosion":
		visible = false
	else:
		pass


func _on_ProjectileAudio_finished():
	queue_free()
