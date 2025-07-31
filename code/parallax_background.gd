extends ParallaxBackground

@onready var play_button = $VBoxContainer/Button
@onready var quit_button = $VBoxContainer/Button2
@onready var confirm_dialog = $QuitConfirmDialog
@onready var guilt_dialog = $PleaseDontLeaveDialog
@onready var leave_timer = $LeaveTimer
@onready var label: Label = $Label
@onready var timer: Timer = $Timer

var scroll_speed: Vector2 = Vector2(50, 0)  # Background scroll speed (pixels/sec)
var label_speed: Vector2 = Vector2(100, 0)  # Label moves fast (pixels/sec)
var showing: bool = false
var time_shown: float = 0.0
const SHOW_DURATION: float = 15.0  # Seconds label stays visible

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	confirm_dialog.confirmed.connect(_on_quit_confirmed)
	confirm_dialog.canceled.connect(_on_quit_canceled)
	guilt_dialog.confirmed.connect(_on_guilt_confirmed)
	guilt_dialog.canceled.connect(_on_guilt_canceled)

	leave_timer.timeout.connect(_quit_game)

func _on_timer_timeout():
	if randi() % 100 == 0: 
		label.visible = true
		showing = true
		time_shown = 0.0
		# Start label just off left side

func _process(delta):
	# Scroll the background
	scroll_offset += scroll_speed * delta

	# Move label if showing, hide after 15 seconds
	if showing:
		label.position += label_speed * delta
		time_shown += delta
		if time_shown >= SHOW_DURATION:
			label.visible = false
			showing = false

func _on_play_pressed():
	get_tree().change_scene_to_file("res://nodes/main scene.tscn")

func _on_quit_pressed():
	confirm_dialog.popup_centered()

func _on_quit_confirmed():
	guilt_dialog.popup_centered()

func _on_quit_canceled():
	# Nothing, they changed their mind
	pass

func _on_guilt_confirmed():
	leave_timer.start()  # Wait, then quit

func _on_guilt_canceled():
	# They chose to stay after guilt trip 😅
	pass

func _quit_game():
	get_tree().quit()
