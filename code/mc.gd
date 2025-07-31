extends CharacterBody2D

@export var walk_speed := 100
@export var run_speed := 200
@export var acceleration := 1000.0
@export var friction := 800.0
@export var gravity := 1200.0
@export var jump_force := -400.0

var last_direction := Vector2.RIGHT
var jumping := false  # 👈 added for camera to read

@onready var anim_sprite := $AnimatedSprite2D

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		0
	).normalized()

	var is_running := Input.is_action_pressed("run")
	var current_speed := run_speed if is_running else walk_speed

	# Apply gravity
	velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		jumping = true  # 👈 jumping now

	# Check landing
	if is_on_floor() and velocity.y >= 0:
		jumping = false  # 👈 landed

	# Horizontal movement
	if input_vector.x != 0:
		velocity.x = move_toward(velocity.x, input_vector.x * current_speed, acceleration * delta)

		# Animation and flip
		if is_running:
			anim_sprite.play("run")
		else:
			anim_sprite.play("walk")

		anim_sprite.flip_h = input_vector.x < 0
		last_direction = input_vector
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		anim_sprite.play("idle")
		if last_direction.x != 0:
			anim_sprite.flip_h = last_direction.x < 0

	move_and_slide()
