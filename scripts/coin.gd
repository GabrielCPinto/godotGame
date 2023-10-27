extends Area2D

@export var coins := 1
@onready var coin_sfx = $coin_sfx as AudioStreamPlayer

func _on_body_entered(body):
	$anim.play("collect")
	coin_sfx.play()
	await $collision.call_deferred("queue_free")
	Globals.coins += coins

func _on_anim_animation_finished():
	if $anim.animation == "collect":
		queue_free()
