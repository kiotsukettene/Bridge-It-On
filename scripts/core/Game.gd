extends Node2D

@onready var controls = $Controls
@onready var level_container = $LevelContainer
@onready var bridge_builder = $BridgeBuilder
@onready var build_toolbar = $BuildToolBar 

var current_level: Node = null

func _ready():
	var level_path = Global.selected_level_path
	if level_path == "":
		level_path = "res://levels/Level3.tscn"
	load_level(level_path)

	# Connect button signals
	controls.play_pressed.connect(_on_play_pressed)
	controls.pause_pressed.connect(_on_pause_pressed)
	controls.erase_pressed.connect(_on_erase_pressed)
	controls.reset_pressed.connect(_on_reset_pressed)
	$BackButton.pressed.connect(_on_back_pressed)


	build_toolbar.material_selected.connect(_on_material_selected)

func load_level(path: String):
	if current_level:
		current_level.queue_free()
	
	var scene = load(path).instantiate()
	level_container.add_child(scene)
	current_level = scene

	await get_tree().process_frame
	bridge_builder.refresh_anchors()

func _on_play_pressed():
	get_tree().paused = false
	for v in get_tree().get_nodes_in_group("vehicles"):
		v.driving = true
		
	for beam in get_tree().get_nodes_in_group("user_supports"):
		if beam.has_method("set_build_mode"):
			beam.set_build_mode(false)

	for anchor in get_tree().get_nodes_in_group("anchors"):
		if anchor.has_method("set_build_mode"):
			anchor.set_build_mode(false)
			
	if current_level and current_level.has_method("compute_bridge_stiffness"):
		var data = current_level.compute_bridge_stiffness()
		var stiffness_value = data["total_stiffness"]

	# Apply damping multiplier
		for beam in get_tree().get_nodes_in_group("user_supports"):
			if beam is RigidBody2D:
				var damp_mult = clamp(stiffness_value * 0.5, 0.5, 3.0)
				beam.linear_damp = 2.0 * damp_mult
				beam.angular_damp = 2.0 * damp_mult


func _on_pause_pressed():
	for v in get_tree().get_nodes_in_group("vehicles"):
		v.driving = false
	for beam in get_tree().get_nodes_in_group("user_supports"):
		if beam.has_method("set_build_mode"):
			beam.set_build_mode(true)
	for anchor in get_tree().get_nodes_in_group("anchors"):
		if anchor.has_method("set_build_mode"):
			anchor.set_build_mode(true)

func _on_erase_pressed():
	_erase_user_supports()
	for v in get_tree().get_nodes_in_group("vehicles"):
		v.driving = false

func _erase_user_supports():
	for beam in get_tree().get_nodes_in_group("user_supports"):
		beam.queue_free()
	
	for anchor in get_tree().get_nodes_in_group("user_anchors"):
		anchor.queue_free()
		
func _on_reset_pressed():
	load_level(Global.selected_level_path)
	await get_tree().process_frame
	_on_erase_pressed()
	for v in get_tree().get_nodes_in_group("vehicles"):
		v.driving = false
	for beam in get_tree().get_nodes_in_group("user_supports"):
		if beam.has_method("set_build_mode"):
			beam.set_build_mode(true)
	for anchor in get_tree().get_nodes_in_group("anchors"):
		if anchor.has_method("set_build_mode"):
			anchor.set_build_mode(true)

func _on_material_selected(material_type: String):
	if bridge_builder:
		bridge_builder.set_build_material(material_type)

func _on_back_pressed():
	ButtonSound.play_sound()
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")
