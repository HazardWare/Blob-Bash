#@tool
@icon("res://meta/icons/player.png")
extends CharacterBody2D
class_name player

# STATUS VARIABLES
@export_category("Player Status")
@export var id = 1 # PLAYER ID (SHOULD GO UP WITH EVERY PLAYER THAT JOINS, USED TO HANDLE EVERYTHING)
@export var is_alive = true
@export var currentModifier: Array[Variables.POWERUPS]
var data = PlayerManager.player_data["Player_%s" % [id]]
var scale_modifier = Vector2(1,1)

# PHYSICS VARIABLES
@export_category("Physics")
@export var move_speed = 300.0
@export var jump_speed = -400.0
@export var gravity = 980
@export_range(0.0, 1.0, 0.05) var friction = 0.5



# COSMETIC VARIABLES
@export_category("Cosmetic")
var offset_amount = 1 # DON'T WORRY ABOUT THIS BUT IT'S USED FOR THE BODY LAG BEHIND EFFECT
#@export_color_no_alpha var colorRgb = Color(255, 255, 255)
@export_enum("angry", "happy", "sad", "shock") var faceType = 'happy'
@export_enum("none", "tophat", "bow", "fluff", "antennae", "moth1", "moth2", "flower", "crown", "bag", "note", "beanie", "crab", "core") var cosmetic = "none"


# STARTING VARIABLES
@export_category("Starting")
@export var start = global_position



enum {IDLE, RUN, JUMP, FALL, SLAM}
var state = IDLE
var jumps = 2
var splatterScene = load("res://particles/splatter.tscn")



func _ready():
	if PlayerManager.player_data.has("Player_%s" % [id]):
		data = PlayerManager.player_data["Player_%s" % [id]]
	else:
		data = PlayerManager.player_data["Base"]
	change_state(IDLE)
	set_player_stats()
	if is_alive:
		if get_tree().get_first_node_in_group("cameras"):
			get_tree().get_first_node_in_group("cameras").add_target(self)
	position = start
	restart()



func _physics_process(delta):
	# RUN IN ENGINE
	if Engine.is_editor_hint():
		set_player_stats()
		start = position
		position = start
		return
	# RESTART ACTION
	if Input.is_action_just_pressed("restart_temp"):
		restart()
	set_player_stats()

	if is_alive == true:
		# CLAMP BODY LAG BEHIND EFFECT
		var bodyLag = Vector2(
			clamp(-velocity.x * delta * offset_amount * 3, -5, 5), # X LAG CLAMP
			clamp(-velocity.y * delta * offset_amount * 3, -5, 5) # Y LAG CLAMP
		)
		$Body.offset = $Body.offset.lerp(bodyLag, delta * 30) # TWEEN OFFSET
		$Body/BodyOccluder.position = $Body/BodyOccluder.position.lerp(bodyLag, delta * 30) # TWEEN OFFSET


		scale = scale.lerp(scale_modifier, delta * 3)
		


		# GRAVITY
		if not is_on_floor():
			velocity.y += gravity * delta
			# SLAM ACTION
			if InputMap.has_action("slam_%s" % [id - 1]):
				if Input.is_action_just_pressed("slam_%s" % [id - 1]):
					velocity.y = 1000
					change_state(SLAM)
		else:
			velocity.y = 0



		# # JUMP ACTION
		if InputMap.has_action("jump_%s" % [id - 1]):
			if Input.is_action_just_pressed("jump_%s" % [id - 1]) and jumps > 0:
				jumps -= 1
				velocity.y = jump_speed
				change_state(JUMP)
		if is_on_floor():
			jumps = 2



		# # LEFT RIGHT ACTIONS
		if InputMap.has_action("moveLeft_%s" % [id -1 ]) and InputMap.has_action("moveRight_%s" % [id - 1]):
			var direction = Input.get_axis("moveLeft_%s" % [id -1 ], "moveRight_%s" % [id - 1]) # GET L/R MOVEMENT PRESSES
			if direction:
				velocity.x = direction * move_speed
			else:
				velocity.x = lerp(velocity.x, 0.0, friction)



		# # SPLATTER PARTICLE
		if (velocity.x < -5 || velocity.x > 5) and is_on_floor():
			#add_child(splatterScene.instantiate())
			pass



		# MOVE AND COLLIDE
		move_and_slide()
		# CHANGE STATE DEPENDING ON COLLISIONS AND STUFF
		manage_state()


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 



func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			pass
		RUN:
			pass
		JUMP:
			pass
		FALL:
			pass

func manage_state():
	if velocity.x > 0:
		$Body.flip_h = false
		$Head.flip_h = false
		$Head.offset.x = 3
		$Face.offset.x = 4
		$Body/BodyOccluder.scale = scale_modifier
		$Head/HeadOccluder.scale = scale_modifier
		$Collision.position.x = 3
		$CollisionArea/Collision.position.x = 3
	elif velocity.x < 0:
		$Body.flip_h = true
		$Head.flip_h = true
		$Head.offset.x = -3
		$Face.offset.x = -4
		$Body/BodyOccluder.scale = -scale_modifier
		$Head/HeadOccluder.scale = -scale_modifier
		$Collision.position.x = -3
		$CollisionArea/Collision.position.x = -3

	if state == JUMP and velocity.y > 0:
		change_state(FALL)

	if state in [JUMP,FALL] and is_on_floor():
		change_state(IDLE)

	if state == IDLE and velocity.x != 0:
		change_state(RUN)

	if state == RUN and velocity.x == 0:
		change_state(IDLE)

	if state in [IDLE,RUN] and !is_on_floor():
		change_state(FALL)



# SET COSMETICS
func set_player_stats():
	modulate = data.get("color")
	$Light.color = data.get("color")
	$Face.play(data.get("face"))
	$Identifier.text = "P%s" % [id]



# DETECT HIT
func _on_hurtzone_body_entered(receiving: Node2D) -> void:
	if receiving == self:
		return

	var collisionarea_top_y = self.global_position.y - ($CollisionArea/Collision.shape.extents.y if $CollisionArea/Collision.shape is RectangleShape2D else 0)
	if receiving.global_position.y < collisionarea_top_y and receiving.velocity.y > 0:
		kill()



func kill():
	position = start
	velocity = Vector2(0, 0)



func restart():
	#if get_tree().get_nodes_in_group("players"):
	for player in get_tree().get_nodes_in_group("players"):
		position = start
		velocity = Vector2(0, 0)
		


func get_powerup(type, duration, strength):
	currentModifier.append(type)
	
	match type:
		Variables.POWERUPS.enlarge:
			print("Enlarged Player %s" % [id])
			scale_modifier += Vector2(strength, strength)
		Variables.POWERUPS.speed:
			pass
		_:
			print("No powerup '"+str(type)+"' applied to Player "+ str(id))


func powerup_sequence(type, duration):
	await get_tree().create_timer(duration).timeout
