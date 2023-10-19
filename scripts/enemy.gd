extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0

@onready var texture := $texture as Sprite2D
@onready var wall_detector := $wall_detector as RayCast2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction := -1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		texture.flip_h = !texture.flip_h
	
	velocity.x = direction * delta * SPEED
	
	move_and_slide()
