extends EnemyBase

const FIREBALL = preload("res://prefabs/fireball.tscn")
var health_points := 2
@onready var sprite = $sprite
@onready var fireball_spawn = $fireball_spawn
@onready var ground_detector = $ground_detector
@onready var player_detector = $player_detector

enum EnemyState {PATROL, ATTACK, HURT}
var curr_state = EnemyState.PATROL
@export var target : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	texture = sprite
	anim = $anim


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match(curr_state):
		EnemyState.PATROL : patrol_state(delta)
		EnemyState.ATTACK : attack_state()
	

func attack_state():
	anim.play("shooting")
	if !player_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func hurt_state():
	anim.play("hurt")
	await get_tree().create_timer(0.3).timeout
	_change_state(EnemyState.PATROL)
	if health_points > 0:
		health_points -= 1
	else:
		queue_free()

func patrol_state(delta):
	anim.play("running")
	_apply_gravity(delta)
	
	if is_on_wall() or !ground_detector.is_colliding():
		direction *= -1
		sprite.scale.x *= -1
		player_detector.scale.x *= -1
		fireball_spawn.position.x *= -1
	
	if player_detector.is_colliding():
		_change_state(EnemyState.ATTACK)
	
	movement(delta)

func _change_state(state):
	curr_state = state

func spawn_fireball():
	var new_fireball = FIREBALL.instantiate()
	if sign(fireball_spawn.position.x) == 1:
		new_fireball.set_dir(-1)
	else:
		new_fireball.set_dir(1)
	add_sibling(new_fireball)
	new_fireball.global_position = fireball_spawn.global_position

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
