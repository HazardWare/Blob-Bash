extends Node

# ACTIVE CONTROLLERS
var activeControllers = [1,2]

# PLAYER DATA
var player_data = {
	"Base": {
		"color": Color8(255, 255, 255),
		"face": "happy",
		"hat": "none"
	},
	"Player_1": {
		"color": Color8(255, 99, 122),
		"face": "angry",
		"hat": "none"
	},
	"Player_2": {
		"color": Color8(53, 147, 255),
		"face": "sad",
		"hat": "none"
	},
	"Player_3": {
		"color": Color8(255, 180, 130),
		"face": "shock",
		"hat": "none"
	}
}

func _ready() -> void:
	go()

func go() -> void:
	for player_id in activeControllers:	# SPAWN A PLAYER FOR ALREADY ACTIVE CONTROLLERS
		add_controller()



# GET INPUTS
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("add_player_temp"):
		add_controller()
	if Input.is_action_just_pressed("remove_player_temp"):
		remove_controller()



# ADD CONTROLLER -> SPAWN PLAYER
func add_controller():
	if activeControllers.size() < 4:
		activeControllers.append(activeControllers.size() + 1)
		spawn_player(activeControllers.size())



# REMOVE CONTROLLER -> REMOVE COORESPONDING PLAYER
func remove_controller():
	if activeControllers.size() > 0:
		var player_id = activeControllers.pop_back()
		remove_player(player_id)



# SPAWN PLAYER USING ID
func spawn_player(player_id: int):
	for spawner in get_tree().get_nodes_in_group("spawnpoints"):
		if spawner.id == player_id:
			spawner.spawn()
			print_rich("[color=green]Spawned[/color] Player%s" % player_id)



# REMOVE PLAYER USING ID
	#for spawner in get_tree().get_nodes_in_group("spawnpoints"):
		#if spawner.instanceName != null:
			#get_tree().get_first_node_in_group(spawner.instanceName).queue_free()
			#return
	#
func remove_player(player_id: int):
	for player in get_tree().get_nodes_in_group("players"):
		if int(player.id) == player_id:
			if player.is_alive:
				get_tree().get_first_node_in_group("cameras").remove_target(player)
				player.queue_free()
				print_rich("[color=red]Removed[/color] " + player.name)
			return
