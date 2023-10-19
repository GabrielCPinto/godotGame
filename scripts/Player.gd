extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback_vector := Vector2.ZERO
var direction
var is_hurt := false

@export var player_life := 3

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_set_state()
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	move_and_slide()


func _on_hurtbox_body_entered(body):	
	if player_life <= 0:
		queue_free()
	else:
		if $ray_right.is_colliding():
			take_damage(Vector2(-200,-200))
		elif $ray_left.is_colliding():
			take_damage(Vector2(200,-200))

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.tween_property(animation, "modulate", Color(1,1,1,1), duration)
	
	is_hurt = true
	await get_tree().create_timer(.3).timeout
	is_hurt = false

func _set_state():
	var state = "idle"
	
	if is_hurt:
		state = "hurt"
	elif !is_on_floor():
		state = "jump"
	elif direction:
		state = "run"
	
	if animation.name != state:
		animation.play(state)

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
