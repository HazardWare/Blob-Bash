extends Camera2D

# DEFINE CAMERA VARIABLES
@export var move_speed = 0.5
@export var zoom_speed = 0.1
@export var min_zoom = 1
@export var max_zoom = 5
@export var zoom_margin = 500.0  # MARGIN SPACE AROUND TARGETS

# GET GAME SIZE
@onready var screen_size = get_viewport_rect().size

# INSTANTIATE CAMERA TARGETS
var targets = [] 

# ADD CAMERA TARGET
func add_target(t):
	if not t in targets: # IF NEW TARGET NOT ALREADY A TARGET THEN...
		targets.append(t) # INVITE THEM IN FOR TEA!!!

# REMOVE CAMERA TARGET
func remove_target(t):
	if t in targets: # IF TARGET IS REAL THEN...
		targets.remove_at(targets.find(t)) # BANISH THEM!!!

func _process(_delta):
	if !targets:
		return
	
	# FIND AVERAGE POSITION OF ALL TARGETS
	var new_position = calculate_average_position() # USE SUPER COOL FUNCTIONS RETURN VALUE AS A POINTER FOR THE CAMERAS MOVEMENT!!!
	position = lerp(position, new_position, move_speed) # MOVEEEE!!!!!!!!

	# ZOOM ACCORDING TO BOUNDING BOX
	var target_zoom = calculate_target_zoom() # USE SUPER COOL FUNCTIONS RETURN VALUE AS A ZOOM LEVEL!!!
	zoom = lerp(zoom, Vector2(target_zoom, target_zoom), zoom_speed) # ZOOOOooom!

# FIND AVERAGE POSITION OF ALL TARGETS (FUNCTION)
func calculate_average_position() -> Vector2:
	var avg_position = Vector2.ZERO
	for target in targets:
		avg_position += target.position
	return avg_position / targets.size()

# ZOOM ACCORDING TO BOUNDING BOX (FUNCTION)
func calculate_target_zoom() -> float:
	if targets.size() < 2: # IF THERES 1 TARGET THEN...
		return 1.5  # SET ZOOM LEVEL TO 1

	var min_pos = targets[0].position
	var max_pos = targets[0].position

	# GET TARGETS BOUNDING BOX
	for target in targets: # FOR ALL EXISTING TARGETS...
		min_pos.x = min(min_pos.x, target.position.x) # SET MINIMUM BOUNDING BOX X
		min_pos.y = min(min_pos.y, target.position.y) # SET MINIMUM BOUNDING BOX Y
		max_pos.x = max(max_pos.x, target.position.x) # SET MAXIMUM BOUNDING BOX X
		max_pos.y = max(max_pos.y, target.position.y) # SET MAXIMUM BOUNDING BOX Y

	var bounding_box_size = max_pos - min_pos
	bounding_box_size += Vector2(zoom_margin, zoom_margin)  # ADD MARGIN TO BOUNDING BOX

	# CALCULATE ZOOM BASED ON SCREEN SIZE AND BOUNDING BOX SIZE
	var zoom_x = screen_size.x / bounding_box_size.x
	var zoom_y = screen_size.y / bounding_box_size.y
	var target_zoom = min(zoom_x, zoom_y) # SET NEXT ZOOM

	# RESTRICT ZOOM TO LIMITS
	return clamp(target_zoom, min_zoom, max_zoom)
