@icon("res://meta/icons/spawnpoint.png")
extends Node

@export var id = 1

var playerScene = load("res://char/player.tscn")

func _ready() -> void:
	self.visible = false


func spawn() -> void:
	#if active == true:
	var player = playerScene.instantiate()
	player.start = self.global_position
	player.id = id
	player.name = "Player%s" % player.id
	#player.set_player_stats()

	add_sibling(player)
