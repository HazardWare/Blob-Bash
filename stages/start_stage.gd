extends Node

@export var flashlights = false

func _ready() -> void:
	PlayerManager.go()
	
func _process(delta: float) -> void:
	if flashlights:
		for player in get_tree().get_nodes_in_group("players"):
			player.get_node("Light").visible = true
	elif not flashlights:
		for player in get_tree().get_nodes_in_group("players"):
			player.get_node("Light").visible = false
