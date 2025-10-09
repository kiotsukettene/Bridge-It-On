extends Node

@onready var music_sound: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(music_sound)

	# Load the background music
	var stream = preload("res://sounds/Music.mp3")

	# Enable looping if supported (e.g., AudioStreamMP3, OggVorbis)
	if stream.has_method("set_loop"):
		stream.set_loop(true)
	elif "loop" in stream:
		stream.loop = true

	music_sound.stream = stream
	music_sound.volume_db = -5  # optional: adjust volume

	# Play automatically once loaded
	if not music_sound.playing:
		music_sound.play()

# Function to play or resume
func play_music():
	if not music_sound.playing:
		music_sound.play()

# Function to stop
func stop_music():
	if music_sound.playing:
		music_sound.stop()
