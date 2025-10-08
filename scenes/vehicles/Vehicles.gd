# Vehicle.gd
extends RigidBody2D
class_name Vehicle

@export var wheel_torque: float = 6000.0     # base torque (N·m)
@export var torque_scale: float = 1.0        # per-vehicle multiplier
@export var wheel_friction: float = 1.0      # physics material friction
@export var wheel_radius_px: float = 16.0    # wheel radius in pixels (optional)
@onready var left_wheel: RigidBody2D = $LeftWheel
@onready var right_wheel: RigidBody2D = $RightWheel

var driving: bool = false

# idle sleep thresholds
const SLEEP_LINEAR_THRESH: float = 0.05
const SLEEP_ANGULAR_THRESH: float = 0.05
const SLEEP_TIME_THRESH: float = 0.25
var _still_time: float = 0.0

func _ready() -> void:
	add_to_group("vehicles")
	_set_wheel_material()
	# ensure wheels exist
	if not left_wheel or not right_wheel:
		push_warning("Vehicle: wheels not found (LeftWheel/RightWheel).")

func _physics_process(delta: float) -> void:
	if driving:
		_apply_drive_torque(delta)
		_still_time = 0.0
	else:
		_auto_sleep_check(delta)


func _apply_drive_torque(delta: float) -> void:
	var impulse: float = wheel_torque * torque_scale * delta
	if left_wheel and left_wheel is RigidBody2D:
		left_wheel.apply_torque_impulse(impulse)
	if right_wheel and right_wheel is RigidBody2D:
		right_wheel.apply_torque_impulse(impulse)

func _auto_sleep_check(delta: float) -> void:
	if linear_velocity.length() < SLEEP_LINEAR_THRESH and abs(angular_velocity) < SLEEP_ANGULAR_THRESH:
		_still_time += delta
		if _still_time >= SLEEP_TIME_THRESH:
			sleeping = true
	else:
		_still_time = 0.0
		if sleeping:
			sleeping = false


# Create/apply a PhysicsMaterial (Godot 4) for wheels
func _set_wheel_material() -> void:
	var mat: PhysicsMaterial = PhysicsMaterial.new()
	mat.bounce = 0.0
	mat.friction = wheel_friction
	if left_wheel:
		left_wheel.physics_material_override = mat
	if right_wheel:
		right_wheel.physics_material_override = mat
