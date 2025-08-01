extends CharacterBody2D

@export var walk_speed := 100
@export var run_speed := 200
@export var acceleration := 1000.0
@export var friction := 800.0
@export var gravity := 1000.0
@export var jump_force := -500.0

var last_direction := Vector2.RIGHT
@onready var anim_sprite := $AnimatedSprite2D

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	var is_running = Input.is_action_pressed("run")
	var speed = run_speed if is_running else walk_speed

	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force
	else:
		velocity.y += gravity * delta

	if input_vector.x != 0:
		velocity.x = move_toward(velocity.x, input_vector.x * speed, acceleration * delta)
		last_direction.x = input_vector.x
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

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
