extends CharacterBody2D

const box_pieces = preload("res://prefabs/box_pieces.tscn")
const coin_instance = preload("res://prefabs/coin_rigid.tscn")

@onready var animation_player := $anim as AnimationPlayer
@onready var hit_block = $hit_block as AudioStreamPlayer
@onready var spawn_coin = $spawn_coin

@export var pieces : PackedStringArray
@export var hitpoints := 3
var impulse := 200

func break_sprite():
	for piece in pieces:
		var piece_instance = box_pieces.instantiate()
		add_sibling(piece_instance)
		piece_instance.get_node("texture").texture = load(piece)
		piece_instance.global_position = global_position
		piece_instance.apply_impulse(Vector2(randi_range(-impulse, impulse),randi_range(-impulse, -impulse * 2)))
	queue_free()

func create_coin():
	var coin = coin_instance.instantiate()
	call_deferred("add_sibling",coin)#
	coin.global_position = spawn_coin.global_position
	coin.global_position -= get_parent().global_position
	coin.apply_impulse(Vector2(randi_range(-50, 50), -150))
