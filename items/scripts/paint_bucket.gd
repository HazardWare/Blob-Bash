@icon("res://meta/icons/bucket.png")
extends Area2D


@export var type : Variables.POWERUPS
@export_range(0, 30, 0.5) var duration = 10.0
@export_range(0, 3, 0.5) var strength = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(_receiving: Node2D) -> void:
	if _receiving.is_in_group("players"):
		_receiving.get_powerup(type, duration, strength)
		queue_free()
