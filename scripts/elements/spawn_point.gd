extends Node2D

const PLAYER = preload("res://scenes/player/player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = PLAYER.instantiate()
	add_child(player)
