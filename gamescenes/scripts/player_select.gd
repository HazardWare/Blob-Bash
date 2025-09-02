extends Node

func _ready() -> void:
	print("Active Players: " + str(PlayerManager.activeControllers))

	#for activeController in PlayerManager.activeControllers:
		#var player = activeController
		#var new_container = get_node("SplitContainer/Players/Base").duplicate()
		#$SplitContainer/Players/Base.queue_free()
		
		
		#new_container.id = player
		
		#get_node("SplitContainer/Players").add_child(new_container)
		#new_container.go()
