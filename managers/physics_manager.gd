extends Node



func _process(_delta: float) -> void:
	@warning_ignore("narrowing_conversion")
	Engine.set_physics_ticks_per_second(DisplayServer.screen_get_refresh_rate() * 3)
