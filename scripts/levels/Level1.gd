extends BaseLevel

func _ready() -> void:
	# Override parent settings
	max_safe_bend = 20.0
	max_warning_bend = 45.0
	max_fail_bend = 70.0
	break_threshold = 80.0

	# Always call parent’s _ready to keep its setup
	super._ready()
