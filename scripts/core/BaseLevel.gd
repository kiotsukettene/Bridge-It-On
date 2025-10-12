extends Node2D
class_name BaseLevel

@export var floor_parent_path: NodePath = "Floor"
@export var print_interval: float = 0.3
@export var max_safe_bend: float = 10.0
@export var max_warning_bend: float = 30.0
@export var max_fail_bend: float = 50.0
@export var break_threshold: float = 80.0

var rest_positions: Dictionary = {}
var average_deflection: float = 0.0
var peak_deflection: float = 0.0
var time_accum: float = 0.0
var floor_beam_count: int = 0
var beam_peak_deflections: Dictionary = {}

const MATERIAL_STIFFNESS := {
	"wood": 1.0,  
	"metal": 3.0 
}

func _ready() -> void:
	await get_tree().process_frame
	_cache_rest_positions()
	_connect_finish_flag()
	print("[Bridge] Tracking %d FloorBeams for deflection..." % rest_positions.size())


func _connect_finish_flag() -> void:
	var flag := get_node_or_null("RightTerrain/FinishFlag")
	if flag and flag.has_signal("level_complete"):
		flag.connect("level_complete", Callable(self, "_on_level_complete"))
		print("[Level] Connected FinishFlag")
	else:
		push_warning("FinishFlag not found in RightTerrain")


func _physics_process(delta: float) -> void:
	time_accum += delta
	if time_accum < print_interval:
		return
	time_accum = 0.0

	if rest_positions.is_empty():
		return

	var floor_parent := get_node_or_null(floor_parent_path)
	if not floor_parent:
		return

	for beam in floor_parent.get_children():
		if beam is RigidBody2D:
			var rest_y = rest_positions.get(beam.get_path(), beam.global_position.y)
			var deflect = beam.global_position.y - rest_y

			# Smooth the visible effect (so glow fades naturally)
			var current_peak = beam_peak_deflections.get(beam.get_path(), 0.0)
			var smoothed_deflect = lerp(current_peak, deflect, 0.2)
			beam_peak_deflections[beam.get_path()] = smoothed_deflect

			# Record peak deflection for analysis
			if abs(deflect) > abs(current_peak):
				beam_peak_deflections[beam.get_path()] = deflect

			# Update shader color in real time
			if beam.get_child_count() > 0:
				for child in beam.get_children():
					if child is Sprite2D and child.material and child.material is ShaderMaterial:
						child.material.set_shader_parameter("deflection", abs(smoothed_deflect))

			# Track global peak deflection
			if abs(deflect) > abs(peak_deflection):
				peak_deflection = deflect


func _get_deflection_color(deflect: float) -> Color:
	var ratio :float= clamp(deflect / max_fail_bend, 0.0, 1.0)
	var color: Color
	if ratio < 0.25:
		color = Color(0.0, 1.0, 0.4)  # 💚 Neon green
	elif ratio < 0.5:
		color = Color(0.0, 1.0, 1.0).lerp(Color(1.0, 1.0, 0.0), (ratio - 0.25) * 4.0) 
	elif ratio < 0.75:
		color = Color(1.0, 1.0, 0.0).lerp(Color(1.0, 0.5, 0.0), (ratio - 0.5) * 4.0)  
	else:
		color = Color(1.0, 0.0, 0.0)  
	color = color.lightened(0.6)
	color.a = 1.0 
	return color


func _apply_beam_color(beam: Node, color: Color) -> void:
	if beam.has_method("set_modulate"):
		beam.modulate = color
	elif beam.get_child_count() > 0:
		for child in beam.get_children():
			if "modulate" in child:
				# Smooth blend to avoid flicker
				child.modulate = child.modulate.lerp(color, 0.5)


func _on_level_complete(vehicle_name: String) -> void:
	if beam_peak_deflections.size() > 0:
		var total_peak_sum: float = 0.0
		for value in beam_peak_deflections.values():
			total_peak_sum += abs(value)
		average_deflection = total_peak_sum / beam_peak_deflections.size()
	else:
		average_deflection = 0.0

	print("Vehicle reached finish:", vehicle_name)
	print("============================")
	print("Bridge Final Analysis")
	print("----------------------------")
	print("→ Peak deflection recorded (global): %.2f px" % peak_deflection)
	print("→ Average beam peak deflection: %.2f px" % average_deflection)
	print("============================")

	get_tree().paused = true

	var game_root = get_tree().current_scene
	if not game_root.has_node("FEAAnalyser"):
		push_warning("FEAAnalyser not found in scene tree!")
		return

	var fea = game_root.get_node("FEAAnalyser")
	var data = compute_bridge_stiffness()

	fea.show_results(
		name,
		peak_deflection,
		vehicle_name,
		data.total_stiffness,
		data.beam_count,
		data.materials,
		floor_beam_count,
		average_deflection
	)


func _cache_rest_positions() -> void:
	var floor_parent := get_node_or_null(floor_parent_path)
	if not floor_parent:
		push_warning("⚠️ Floor node not found for deflection measurement")
		return

	# Clear old data
	rest_positions.clear()
	beam_peak_deflections.clear()

	# Load the shader material (matches your current file structure)
	var heatmap_mat := load("res://shader/heatmap_material.tres")

	# Counter for FloorBeams
	var beam_count := 0

	for beam in floor_parent.get_children():
		if beam is RigidBody2D:
			rest_positions[beam.get_path()] = beam.global_position.y
			beam_peak_deflections[beam.get_path()] = 0.0
			beam_count += 1

			if beam.get_child_count() > 0:
				for child in beam.get_children():
					if child is Sprite2D:
						var mat := heatmap_mat.duplicate()
						child.material = mat
						break

	# Store the total floor beam count
	floor_beam_count = beam_count

	print("[Bridge] Tracking %d FloorBeams for deflection..." % floor_beam_count)


func compute_bridge_stiffness() -> Dictionary:
	var total_stiffness := 0.0
	var beam_count := 0
	var material_types := []  # temporary list

	for beam in get_tree().get_nodes_in_group("user_supports"):
		if not (beam is RigidBody2D):
			continue

		var material_type := "wood"
		if "build_material" in beam:
			material_type = beam.build_material

		# Add unique material types only once
		if not material_types.has(material_type):
			material_types.append(material_type)

		# Compute stiffness
		var length := 100.0
		if "anchor_a" in beam and "anchor_b" in beam and beam.anchor_a and beam.anchor_b:
			length = beam.anchor_a.global_position.distance_to(beam.anchor_b.global_position)

		var base_stiffness: float = MATERIAL_STIFFNESS.get(material_type, 1.0)
		var beam_stiffness: float = base_stiffness / max(length / 100.0, 0.1)

		total_stiffness += beam_stiffness
		beam_count += 1

	if beam_count == 0:
		return {
			"avg_stiffness": 0.0,
			"total_stiffness": 0.0,
			"beam_count": 0,
			"materials": ""  
		}

	var avg_stiffness := total_stiffness / beam_count

	var materials_text := ", ".join(material_types)

	print("Bridge stiffness calculated:")
	print(" - Total beams:", beam_count)
	print(" - Materials used:", materials_text)
	print(" - Avg stiffness:", avg_stiffness)
	print(" - Total stiffness:", total_stiffness)

	return {
		"avg_stiffness": avg_stiffness,
		"total_stiffness": total_stiffness,
		"beam_count": beam_count,
		"materials": materials_text 
	}
