extends Node2D


func _ready():
	Music.play_music()

	# Connect button signals
	$ButtonCar.pressed.connect(_on_button_pressed)
	$ButtonBus.pressed.connect(_on_button2_pressed)
	$ButtonTruck.pressed.connect(_on_button3_pressed)
	$BackButton.pressed.connect(_on_back_pressed)

func _on_button_pressed():
	ButtonSound.play_sound()
	get_tree().change_scene_to_file("res://levels/Level1.tscn")

func _on_button2_pressed():
	ButtonSound.play_sound()
	get_tree().change_scene_to_file("res://levels/Level2.tscn")

func _on_button3_pressed():
	ButtonSound.play_sound()
	get_tree().change_scene_to_file("res://levels/Level3.tscn")

func _on_back_pressed():
	ButtonSound.play_sound()
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")
