extends Node2D

@export var beam_scene: PackedScene    # Assign Beam.tscn in Inspector
@export var beam_count: int = 5        # How many beams

func _ready():
	if beam_scene == null:
		push_error("Beam scene not assigned in Inspector!")
		return

	var beams: Array = []

	# Instance a temporary beam just to measure its length
	var temp_beam = beam_scene.instantiate()
	var left_marker = temp_beam.get_node("RigidBody2D/LeftJoint")
	var right_marker = temp_beam.get_node("RigidBody2D/RightJoint")
	var beam_length = left_marker.position.distance_to(right_marker.position)
	temp_beam.queue_free() # cleanup

	# Spawn beams in a row
	for i in range(beam_count):
		var beam = beam_scene.instantiate()
		add_child(beam)

		# Position each beam side by side using detected beam_length
		beam.position = Vector2(i * beam_length, 200)
		beams.append(beam)
 
		# Connect to previous beam
		if i > 0:
			var prev_beam = beams[i - 1]

			var joint = PinJoint2D.new()
			joint.node_a = prev_beam.get_path()
			joint.node_b = beam.get_path()

			# Place joint at prev_beam's right marker
			var joint_pos = prev_beam.get_node("RigidBody2D/RightJoint").global_position
			joint.position = joint_pos
			add_child(joint)

	# ---- Anchor the first beam ----
	if beams.size() > 0:
		var anchor = StaticBody2D.new()
		var col = CollisionShape2D.new()
		col.shape = RectangleShape2D.new()
		col.shape.size = Vector2(20, 20)
		anchor.add_child(col)
		anchor.position = beams[0].get_node("RigidBody2D/LeftJoint").global_position
		add_child(anchor)

		var anchor_joint = PinJoint2D.new()
		anchor_joint.node_a = anchor.get_path()
		anchor_joint.node_b = beams[0].get_path()
		anchor_joint.position = anchor.global_position
		add_child(anchor_joint)
