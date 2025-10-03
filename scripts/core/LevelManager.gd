extends Node2D

func _ready():
	# Connect signals using Callable in Godot 4
	$ButtonCar.pressed.connect(_on_button_pressed)
	$ButtonBus.pressed.connect(_on_button2_pressed)
	$ButtonTruck.pressed.connect(_on_button3_pressed)
	$BackButton.pressed.connect(_on_back_pressed)

# Button functions
func _on_button_pressed():
	get_tree().change_scene_to_file("res://levels/Level1.tscn")

func _on_button2_pressed():
	get_tree().change_scene_to_file("res://levels/Level2.tscn")

func _on_button3_pressed():
	get_tree().change_scene_to_file("res://levels/Level3.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")
