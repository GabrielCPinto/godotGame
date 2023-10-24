extends CharacterBody2D

@onready var anim = $anim
@export var score := 150

func _on_hitbox_body_entered(body):
	anim.play("hurt")


func _on_anim_animation_finished():
	if anim.animation == "hurt":
		queue_free()
		Globals.score += score
