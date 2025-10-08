extends Node2D

@export var floor_parent_path: NodePath = "Floor"   
@export var print_interval: float = 0.3           
@export var max_safe_bend: float = 20.0            
@export var max_warning_bend: float = 45.0        
@export var max_fail_bend: float = 70.0            

var rest_positions: Dictionary = {}
var max_deflection: float = 0.0
var average_deflection: float = 0.0
var time_accum: float = 0.0

func _ready() -> void:
	await get_tree().process_frame
	_cache_rest_positions()
	print("[Bridge] Tracking %d FloorBeams for deflection..." % rest_positions.size())


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

	var total_deflection := 0.0
	var count := 0
	var beam_deflections: Array[float] = []

	for beam in floor_parent.get_children():
		if not (beam is RigidBody2D):
			continue

		var rest_y :float= rest_positions.get(beam.get_path(), beam.global_position.y)
		var deflect :float= beam.global_position.y - rest_y
		total_deflection += deflect
		count += 1
		beam_deflections.append(deflect)

		_color_beam_by_deflection(beam, deflect)

	if count == 0:
		return

	average_deflection = total_deflection / count
	max_deflection = max(max_deflection, average_deflection)

	print("============================")
	print("Bridge bending values:")
	for i in beam_deflections.size():
		print("  Beam %d deflection: %.2f px" % [i + 1, beam_deflections[i]])
	print("→ Average deflection: %.2f px" % average_deflection)
	print("→ Max average deflection so far: %.2f px" % max_deflection)
	print("============================")



func _cache_rest_positions() -> void:
	var floor_parent := get_node_or_null(floor_parent_path)
	if not floor_parent:
		push_warning("⚠️ Floor node not found for deflection measurement")
		return

	for beam in floor_parent.get_children():
		if beam is RigidBody2D:
			rest_positions[beam.get_path()] = beam.global_position.y



func _color_beam_by_deflection(beam: Node2D, deflection: float) -> void:
	var color := _get_color_for_deflection(deflection)
	if beam.has_node("Sprite2D"):
		beam.get_node("Sprite2D").modulate = color



func _get_color_for_deflection(deflection: float) -> Color:
	if deflection <= max_safe_bend:
		# Green → Yellow
		var t :float= deflection / max_safe_bend
		return Color(lerp(0.0, 1.0, t), 1.0, 0.0)  # (R, G, B)
	elif deflection <= max_warning_bend:
		# Yellow → Orange
		var t :float= (deflection - max_safe_bend) / (max_warning_bend - max_safe_bend)
		return Color(1.0, lerp(1.0, 0.5, t), 0.0)
	else:
		# Orange → Red
		var t :float= clamp((deflection - max_warning_bend) / (max_fail_bend - max_warning_bend), 0.0, 1.0)
		return Color(1.0, lerp(0.5, 0.0, t), 0.0)
