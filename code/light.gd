extends CharacterBody2D

@export var speed := 2000  # Movement speed in pixels per second

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	var target_pos = get_global_mouse_position()
	var direction = (target_pos - global_position).normalized()
	var distance = global_position.distance_to(target_pos)

	if distance > 5:
		# Move towards mouse smoothly
		global_position += direction * speed * delta
	else:
		# Close enough — stop moving
		global_position = target_pos
