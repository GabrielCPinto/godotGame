extends EnemyBase

@onready var spawn_enemy = $"../spawn_enemy"
@onready var rocket_cherry = $"."

func _ready():
	spawn_instance = preload("res://actors/cherry.tscn")
	spawn_instance_position = rocket_cherry
	can_spawn = true
	anim.animation_finished.connect(kill_air_enemy)
