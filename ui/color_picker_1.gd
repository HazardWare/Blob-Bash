extends ColorPicker

@export var picker_player_id = 1
@onready var data = PlayerManager.player_data["Player_%s" % [picker_player_id]]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	color = data.get("color")


func _process(delta: float) -> void:
	data.color = self.color
