extends RigidBody2D
class_name Vehicle

@export var wheel_torque: float = 6000.0
@onready var left_wheel: RigidBody2D = $LeftWheel
@onready var right_wheel: RigidBody2D = $RightWheel

var driving: bool = false

func _physics_process(delta: float):
	if driving:
		left_wheel.apply_torque(wheel_torque)
		right_wheel.apply_torque(wheel_torque)

func _ready():
	add_to_group("vehicles")
