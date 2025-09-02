extends Sprite2D

@export var id = 1

var data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data = PlayerManager.player_data["Player_%s" % [id]]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	data = PlayerManager.player_data["Player_%s" % [id]]
	modulate = data.get("color")
