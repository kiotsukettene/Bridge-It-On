extends RigidBody2D

signal start_drag(anchor: RigidBody2D)

var build_mode := true  # true while player is constructing

func _ready():
	if not is_in_group("anchors"):
		add_to_group("anchors")

	collision_layer = 1
	collision_mask = 0

	# Start in build mode
	set_build_mode(true)

	input_event.connect(_on_input_event)
	print("Anchor ready:", name, " layer=", collision_layer, " mask=", collision_mask)


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("start_drag", self)


func set_build_mode(active: bool):
	build_mode = active
	if active:
		# Freeze in place (no gravity, no movement)
		sleeping = true
		gravity_scale = 0.0
		lock_rotation = true
	else:
		# Enable physics again
		sleeping = false
		gravity_scale = 1.0
		lock_rotation = false
