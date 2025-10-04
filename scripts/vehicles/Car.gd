extends Vehicle

func _ready():
	super._ready() # keep group registration
	wheel_torque = 8000.0  # car = lighter, faster torque
