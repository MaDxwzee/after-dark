extends GPUParticles2D

func _ready():
	# Create basic rain material
	var material := ParticleProcessMaterial.new()
	material.gravity = Vector2(0, 1000)
	material.direction = Vector2(0, 1)
	material.initial_velocity_min = 300
	material.initial_velocity_max = 400
	material.lifetime = 1.0
	material.lifetime_randomness = 0.2
	material.scale_min = 0.1
	material.scale_max = 0.2

	# Assign material to particle system
	process_material = material

	# Emit from a wide horizontal area using a rectangle shape
	var shape := RectangleShape2D.new()
	shape.size = Vector2(800, 1)  # Width across top of screen
	emission_shape = shape

	# Set particle count and start emitting
	amount = 500
	emitting = true
