extends Node

@onready var button_sound: AudioStreamPlayer = AudioStreamPlayer.new()
var sounds_muted := false  # Global mute toggle

func _ready():
	add_child(button_sound)

	# Load the button sound effect
	button_sound.stream = preload("res://sounds/buttonEffects.mp3")
	button_sound.volume_db = 0  # Normal volume
	button_sound.bus = "SFX"  # optional: if you have a custom audio bus

func play_sound():
	if not sounds_muted and button_sound.stream:
		button_sound.play()

func set_muted(mute: bool):
	sounds_muted = mute
	button_sound.volume_db = -80 if mute else 0
