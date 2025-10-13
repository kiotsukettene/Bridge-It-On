extends Node

func _ready():
	Music.play_music()
	$BackButton.pressed.connect(_on_back_pressed)
	
func _on_back_pressed():
	ButtonSound.play_sound()
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")
