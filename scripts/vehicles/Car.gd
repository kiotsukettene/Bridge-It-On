extends RigidBody2D

@export var wheel_torque: float = 6000.0
@onready var left_wheel: RigidBody2D = $LeftWheel
@onready var right_wheel: RigidBody2D = $RightWheel

func _physics_process(delta: float):
	# Apply torque to wheels so car moves forward
	left_wheel.apply_torque(wheel_torque)
	right_wheel.apply_torque(wheel_torque)
