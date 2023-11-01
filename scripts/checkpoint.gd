extends Area2D

@onready var anim = $anim

var is_active = false

func _on_body_entered(body):
	if body.name == "Player" and !is_active:
		activate_checkpoint()

func activate_checkpoint():
	Globals. current_checkpoint = self
	anim.play("raising")
	is_active = true


func _on_anim_animation_finished():
	if anim.animation == "raising":
		anim.play("checked")
