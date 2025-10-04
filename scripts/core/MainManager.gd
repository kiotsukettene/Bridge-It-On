extends Node2D

@onready var exit_dialog = $ExitConfirmDialog

func _ready():
	# Connect button signals
	$PlayButton.pressed.connect(_on_playbutton_pressed)
	$LevelButton.pressed.connect(_on_levelbutton_pressed)
	$ExitButton.pressed.connect(_on_exitbutton_pressed)
	$HTPButton.pressed.connect(_on_htpbutton_pressed)

	# Connect dialog signals
	exit_dialog.confirmed.connect(_on_exit_confirmed)
	exit_dialog.canceled.connect(_on_exit_canceled)

# Button functions
func _on_playbutton_pressed():
	get_tree().change_scene_to_file("res://levels/Level1.tscn")

func _on_levelbutton_pressed():
	get_tree().change_scene_to_file("res://scenes/main/LevelSelect.tscn")

func _on_exitbutton_pressed():
	# Show confirmation dialog instead of exiting immediately
	exit_dialog.popup_centered()

func _on_htpbutton_pressed():
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")

# Dialog handlers
func _on_exit_confirmed():
	get_tree().quit()

func _on_exit_canceled():
	# Optional: play a sound or print message
	print("Exit canceled")
