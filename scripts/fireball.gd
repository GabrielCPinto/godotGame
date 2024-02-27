extends CharacterBody2D

var move_speed := 50.0
var dir := 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += move_speed * delta * dir

func set_dir(direction):
	dir = direction
	if dir < 0:
		$anim.flip_h = true
	else:
		$anim.flip_h = false
