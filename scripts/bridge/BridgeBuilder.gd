extends Node2D

@export var beam_scene: PackedScene
@export var anchor_scene: PackedScene
@export var snap_distance: float = 24.0
@export var snap_to_grid: bool = true
@export var grid_cell_size: int = 32

var current_material: String = "wood"
var is_drawing := false
var start_anchor: RigidBody2D
var preview_line: Line2D

func _ready():
	preview_line = $Line2D
	preview_line.visible = false

	for anchor in get_tree().get_nodes_in_group("anchors"):
		if not anchor.start_drag.is_connected(_on_anchor_drag_start):
			anchor.start_drag.connect(_on_anchor_drag_start)


func set_build_material(material_type: String):
	current_material = material_type
	print("🪵 BridgeBuilder: material set to ", material_type)


func _snap(pos: Vector2) -> Vector2:
	if not snap_to_grid:
		return pos
	return Vector2(
		round(pos.x / grid_cell_size) * grid_cell_size,
		round(pos.y / grid_cell_size) * grid_cell_size
	)


func _on_anchor_drag_start(anchor: RigidBody2D):
	start_anchor = anchor
	is_drawing = true
	preview_line.visible = true
	preview_line.points = [anchor.global_position, anchor.global_position]


func _process(_delta):
	if is_drawing:
		var mouse_pos = get_global_mouse_position()
		if snap_to_grid:
			mouse_pos = _snap(mouse_pos)
		preview_line.set_point_position(1, mouse_pos)

		if Input.is_action_just_released("click"):
			_finish_drawing(mouse_pos)


func _finish_drawing(mouse_pos: Vector2):
	is_drawing = false
	preview_line.visible = false

	if snap_to_grid:
		mouse_pos = _snap(mouse_pos)

	var end_anchor = _find_nearest_anchor(mouse_pos)
	if end_anchor == null:
		end_anchor = anchor_scene.instantiate()
		get_parent().add_child(end_anchor)
		end_anchor.global_position = mouse_pos
		end_anchor.add_to_group("anchors")
		end_anchor.add_to_group("user_anchors")
		end_anchor.start_drag.connect(_on_anchor_drag_start)
		end_anchor.collision_layer = 1
		end_anchor.collision_mask = 0

		# 🧱 Anchor stabilization
		end_anchor.mass = 2.5
		end_anchor.gravity_scale = 0.5
		end_anchor.linear_damp = 3.0
		end_anchor.angular_damp = 3.0

	# 🪵 Beam stabilization
	var beam = beam_scene.instantiate()
	get_parent().add_child(beam)
	beam.setup(start_anchor, end_anchor, current_material)
	beam.add_to_group("user_supports")

	# Apply physical damping based on material
	match current_material:
		"wood":
			beam.mass = 1.0
			beam.linear_damp = 2.5
			beam.angular_damp = 2.5
		"metal":
			beam.mass = 1.8
			beam.linear_damp = 3.5
			beam.angular_damp = 3.5
		_:
			beam.mass = 1.2
			beam.linear_damp = 2.0
			beam.angular_damp = 2.0

	beam.gravity_scale = 1.0

	_make_joint(beam, start_anchor, start_anchor.global_position)
	_make_joint(beam, end_anchor, end_anchor.global_position)

	start_anchor = null


func _find_nearest_anchor(pos: Vector2) -> RigidBody2D:
	var nearest: RigidBody2D = null
	var best_dist = snap_distance
	for anchor in get_tree().get_nodes_in_group("anchors"):
		var dist = anchor.global_position.distance_to(pos)
		if dist < best_dist:
			best_dist = dist
			nearest = anchor
	return nearest


func _make_joint(beam: RigidBody2D, anchor: RigidBody2D, pos: Vector2):
	var joint := PinJoint2D.new()
	joint.node_a = beam.get_path()
	joint.node_b = anchor.get_path()
	joint.position = pos
	get_parent().add_child(joint)

	# Count how many other beams already connect to this anchor
	var connections = 0
	for child in get_parent().get_children():
		if child is PinJoint2D and (child.node_a == anchor.get_path() or child.node_b == anchor.get_path()):
			connections += 1

	# More connected beams = tighter joint
	var stiffness_scale = clamp(1.0 + connections * 0.25, 1.0, 2.0)

	var spring := DampedSpringJoint2D.new()
	spring.node_a = beam.get_path()
	spring.node_b = anchor.get_path()
	spring.position = pos
	spring.length = 0.0
	spring.rest_length = 0.0

	match current_material:
		"wood":
			spring.stiffness = 1500.0 * stiffness_scale
			spring.damping = 35.0
		"metal":
			spring.stiffness = 6000.0 * stiffness_scale
			spring.damping = 80.0
	get_parent().add_child(spring)




func refresh_anchors():
	print("🔄 Refreshing anchors...")
	for anchor in get_tree().get_nodes_in_group("anchors"):
		if not anchor.start_drag.is_connected(_on_anchor_drag_start):
			anchor.start_drag.connect(_on_anchor_drag_start)
	print("✅ Anchors connected:", get_tree().get_nodes_in_group("anchors").size())
