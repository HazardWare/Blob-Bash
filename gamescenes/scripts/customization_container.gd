extends MarginContainer

var playerScene = load("res://char/player.tscn")
var id
var data

@onready var player = $SplitContainer/Player/Player
@onready var picker = $SplitContainer/Color/MarginColor/ColorPicker

var player_scale = 2.5




func go() -> void:
	data = PlayerManager.player_data["Player_%s" % [id]]
	$Text.text = "Player %s" % [id]

	
	player.is_alive = false
	player.scale = Vector2(player_scale, player_scale)
	
	player.player_id = id
	player.name = "Player%s" % player.player_id
	picker.color = data.color

func _on_color_picker_color_changed(color: Color) -> void:
	data.color = picker.color
	print(picker.color)
