extends Node

var coins := 0
var score := 0
var player_life := 3
var player = null
var current_checkpoint = null
var player_start_position = null

func respawn_player():
	if current_checkpoint:
		player.global_position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position
