extends Node2D

func _ready():
	$ButtonCar.pressed.connect(_on_car_pressed)
	$ButtonBus.pressed.connect(_on_bus_pressed)
	$ButtonTruck.pressed.connect(_on_truck_pressed)
	$BackButton.pressed.connect(_on_back_pressed)

func _on_car_pressed():
	Global.selected_level_path = "res://levels/Level1.tscn"
	get_tree().change_scene_to_file("res://scenes/main/Game.tscn")

func _on_bus_pressed():
	Global.selected_level_path = "res://levels/Level2.tscn"
	get_tree().change_scene_to_file("res://scenes/main/Game.tscn")

func _on_truck_pressed():
	Global.selected_level_path = "res://levels/Level3.tscn"
	get_tree().change_scene_to_file("res://scenes/main/Game.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")
