extends CharacterBody2D
class_name EnemyBase

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

@onready var anim := $anim

@export var score := 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var texture
var wall_detector
var direction := -1

var can_spawn = false
var spawn_instance : PackedScene = null
var spawn_instance_position


func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func movement(delta):
	velocity.x = direction * delta * SPEED
	
	move_and_slide()

func flip_direction():
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		texture.flip_h = !texture.flip_h

func kill_ground_enemy(anim_name: StringName):
	kill_and_score()

func kill_air_enemy():
	kill_and_score()

func kill_and_score():
	Globals.score += score
	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()

func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	get_tree().root.add_child(instance_scene)
	instance_scene.global_position = spawn_instance_position.global_position

func _on_hitbox_body_entered(body):
	anim.play("hurt")
