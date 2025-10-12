extends BaseLevel

func _ready() -> void:
	max_safe_bend = 40.0
	max_warning_bend = 80.0
	max_fail_bend = 120.0
	break_threshold = 130.0
	super._ready()
