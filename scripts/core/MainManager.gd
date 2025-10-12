extends Node2D

@onready var exit_dialog = $ExitConfirmDialog

# Settings and audio buttons
@onready var settings_button = $SettingsButton
@onready var settings_panel = $SettingsPanel
@onready var music_button = $SettingsPanel/MusicButton
@onready var sound_button = $SettingsPanel/SoundButton

var music_muted := false
var sounds_muted := false

func _ready():
	Music.play_music()
	get_tree().paused = false 
	
	# Connect main menu buttons
	$PlayButton.pressed.connect(_on_playbutton_pressed)
	$LevelButton.pressed.connect(_on_levelbutton_pressed)
	$ExitButton.pressed.connect(_on_exitbutton_pressed)
	$HTPButton.pressed.connect(_on_htpbutton_pressed)

	# Connect exit dialog signals
	exit_dialog.confirmed.connect(_on_exit_confirmed)
	exit_dialog.canceled.connect(_on_exit_canceled)

	# Initialize settings panel
	settings_panel.visible = false

	# Connect settings & toggle buttons
	settings_button.mouse_entered.connect(_on_settings_hover)
	settings_button.mouse_exited.connect(_on_settings_unhover)
	settings_button.pressed.connect(_on_settings_pressed)
	music_button.pressed.connect(_on_music_toggle)
	sound_button.pressed.connect(_on_sound_toggle)


#Main Menu Buttons
func _on_playbutton_pressed():
	ButtonSound.play_sound()
	Global.selected_level_path = "res://levels/Level1.tscn"
	get_tree().change_scene_to_file("res://scenes/main/Game.tscn")


func _on_levelbutton_pressed():
	ButtonSound.play_sound()
	get_tree().change_scene_to_file("res://scenes/main/LevelSelect.tscn")

func _on_exitbutton_pressed():
	ButtonSound.play_sound()
	exit_dialog.popup_centered()

func _on_htpbutton_pressed():
	ButtonSound.play_sound()
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")

func _on_exit_confirmed():
	get_tree().quit()

func _on_exit_canceled():
	print("Exit canceled")


#Settings Button Functions
func _on_settings_hover():
	settings_button.modulate = Color(1, 1, 1, 0.9)  # fade effect

func _on_settings_unhover():
	settings_button.modulate = Color(1, 1, 1, 1)    # restore

func _on_settings_pressed():
	ButtonSound.play_sound()
	settings_panel.visible = not settings_panel.visible
	settings_button.modulate = Color(0.8, 0.8, 0.8, 1)


#Music Toggle
func _on_music_toggle():
	ButtonSound.play_sound()
	music_muted = not music_muted
	Music.music_sound.volume_db = -80 if music_muted else -5
	music_button.modulate = Color(0.5, 0.5, 0.5, 1) if music_muted else Color(1, 1, 1, 1)


#Sound Effects Toggle
func _on_sound_toggle():
	ButtonSound.play_sound()
	sounds_muted = not sounds_muted
	sound_button.modulate = Color(0.5, 0.5, 0.5, 1) if sounds_muted else Color(1, 1, 1, 1)
	ButtonSound.set_muted(sounds_muted)
