# Truck.gd
extends Vehicle

func _ready() -> void:
	super._ready()
	wheel_torque = 100000.0  
	torque_scale = 3.0     
	wheel_friction = 1.2
