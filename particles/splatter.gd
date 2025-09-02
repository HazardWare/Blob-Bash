extends Area2D

@export_category("Physics")
@export var part_gravity = 98
@export var radius = 5
@export_color_no_alpha var colorRgb = Color(255, 255, 255)
@export var id = 1
@export var modifier: Array[Variables.POWERUPS]

var is_landed = false

func _ready() -> void:
	if get_parent().is_in_group("players"):
		colorRgb = get_parent().modulate
		self.id = get_parent().id
		modifier = get_parent().currentModifier
	$SplatterParticleS.rotation = randi_range(-360, 360)
	reparent(get_tree().root)

func _process(delta: float) -> void:
	position.y += part_gravity * delta
	
	self.modulate = colorRgb
	if get_node_or_null('SplatterParticleS'):
		#$SplatterParticleS.modulate = colorRgb
		is_landed = true
		check_particles()

func check_particles() -> void:
	var nearby_particles = get_tree().get_nodes_in_group("particles")
	
	for particle in nearby_particles:
		if particle != self and particle.is_landed and position.distance_to(particle.position) < radius:
			queue_free()
			particle.colorRgb = particle.colorRgb.lerp(self.colorRgb, 0.5)
			return

func _on_body_entered(_receiving: Node2D) -> void:
	part_gravity = 0
	$SplatterParticle.emitting = true
	is_landed = true
	check_particles()
	if get_node_or_null('SplatterParticleS'):
		$SplatterParticleS.queue_free()
