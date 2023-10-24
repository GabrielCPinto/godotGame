extends Area2D

@export var coins := 1

func _on_body_entered(body):
	$anim.play("collect")
	await $collision.call_deferred("queue_free")
	Globals.coins += coins

func _on_anim_animation_finished():
	queue_free()
