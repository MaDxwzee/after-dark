extends CharacterBody2D

@export var walk_speed := 100
@export var run_speed := 200
@export var acceleration := 1000.0
@export var friction := 800.0
@export var gravity := 1000.0
@export var min_jump_velocity := -150.0   # Low jump speed
@export var max_jump_velocity := -400.0   # Max jump speed
@export var max_hold_time := 0.3          # Time to reach full jump

var last_direction := Vector2.RIGHT
var is_jumping := false
var jump_time := 0.0

@onready var anim_sprite := $AnimatedSprite2D

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	var is_running = Input.is_action_pressed("run")
	var speed = run_speed if is_running else walk_speed

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Start jump immediately with min velocity
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = min_jump_velocity
		is_jumping = true
		jump_time = 0.0

	# While holding, lerp velocity toward max_jump_velocity
	if is_jumping and Input.is_action_pressed("ui_accept") and velocity.y < 0:
		if jump_time < max_hold_time:
			jump_time = min(jump_time + delta, max_hold_time)
			var hold_ratio = jump_time / max_hold_time
			velocity.y = lerp(min_jump_velocity, max_jump_velocity, hold_ratio)
		else:
			is_jumping = false

	# Stop adjusting when released
	if Input.is_action_just_released("ui_accept") or velocity.y >= 0:
		is_jumping = false

	# Horizontal movement
	if input_vector.x != 0:
		velocity.x = move_toward(velocity.x, input_vector.x * speed, acceleration * delta)
		last_direction.x = input_vector.x
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Animations
	if not is_on_floor():
		if velocity.y < 0:
			anim_sprite.play("jump")
		else:
			anim_sprite.play("fall")
	elif input_vector.x != 0:
		anim_sprite.play("run" if is_running else "walk")
	else:
		anim_sprite.play("idle")

	anim_sprite.flip_h = last_direction.x < 0

	move_and_slide()
