extends CanvasLayer

signal play_pressed
signal pause_pressed
signal erase_pressed
signal reset_pressed

@onready var play_button:Button = $PlayButton
@onready var pause_button:Button = $PauseButton
@onready var erase_button:Button = $EraseButton
@onready var reset_button: Button = $ResetButton

func _ready():
	# Connect button presses to signals
	play_button.pressed.connect(func(): emit_signal("play_pressed"))
	pause_button.pressed.connect(func(): emit_signal("pause_pressed"))
	erase_button.pressed.connect(func(): emit_signal("erase_pressed"))
	reset_button.pressed.connect(func(): emit_signal("reset_pressed"))
