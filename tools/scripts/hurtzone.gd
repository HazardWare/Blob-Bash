extends Area2D

func _ready() -> void:
	self.visible = false

func _on_body_entered(body: Node2D) -> void:
	body.kill()
