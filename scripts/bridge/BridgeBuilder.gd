extends Node2D

@export var beam_scene: PackedScene   # your support Beam.tscn
@export var anchor_scene: PackedScene # for creating new anchors if needed
@export var snap_distance: float = 24.0

var is_drawing := false
var start_anchor: StaticBody2D
var preview_line: Line2D

func _ready():
	# Assume a Line2D is a child for preview
	preview_line = $Line2D
	preview_line.visible = false

	# Connect all anchors in scene
	for anchor in get_tree().get_nodes_in_group("anchors"):
		anchor.start_drag.connect(_on_anchor_drag_start)

func _on_anchor_drag_start(anchor: StaticBody2D):
	start_anchor = anchor
	is_drawing = true
	preview_line.visible = true
	preview_line.points = [anchor.global_position, anchor.global_position]

func _process(_delta):
	if is_drawing:
		var mouse_pos = get_global_mouse_position()
		preview_line.set_point_position(1, mouse_pos)

		if Input.is_action_just_released("click"): # "click" = LMB in InputMap
			_finish_drawing(mouse_pos)

func _finish_drawing(mouse_pos: Vector2):
	is_drawing = false
	preview_line.visible = false

	var end_anchor = _find_nearest_anchor(mouse_pos)
	if end_anchor == null:
		# create new anchor at release point
		end_anchor = anchor_scene.instantiate()
		get_parent().add_child(end_anchor)
		end_anchor.global_position = mouse_pos
		end_anchor.add_to_group("anchors")
		end_anchor.start_drag.connect(_on_anchor_drag_start)

		# ✅ Fix: make sure spawned anchors are in the correct collision layer/mask
		end_anchor.collision_layer = 1   # Anchors layer only
		end_anchor.collision_mask = 0    # No collisions

	# create beam
	var beam = beam_scene.instantiate()
	get_parent().add_child(beam)
	beam.setup(start_anchor, end_anchor)

	# connect beam physics
	_make_joint(beam, start_anchor, start_anchor.global_position)
	_make_joint(beam, end_anchor, end_anchor.global_position)

	start_anchor = null


func _find_nearest_anchor(pos: Vector2) -> StaticBody2D:
	var nearest: StaticBody2D = null
	var best_dist = snap_distance
	for anchor in get_tree().get_nodes_in_group("anchors"):
		var dist = anchor.global_position.distance_to(pos)
		if dist < best_dist:
			best_dist = dist
			nearest = anchor
	return nearest

func _make_joint(beam: RigidBody2D, anchor: StaticBody2D, pos: Vector2):
	var joint := PinJoint2D.new()
	joint.node_a = beam.get_path()
	joint.node_b = anchor.get_path()
	joint.position = pos
	get_parent().add_child(joint)
