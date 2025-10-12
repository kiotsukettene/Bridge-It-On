extends BaseLevel

func _ready() -> void:
	max_safe_bend = 30.0
	max_warning_bend = 60.0
	max_fail_bend = 90.0
	break_threshold = 100.0
	super._ready()
