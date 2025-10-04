extends Node2D

@onready var controls = $Controls
@onready var level_container = $LevelContainer
@onready var bridge_builder = $BridgeBuilder

var current_level: Node = null

func _ready():
	load_level("res://levels/Level1.tscn")

	# Connect button signals
	controls.play_pressed.connect(_on_play_pressed)
	controls.pause_pressed.connect(_on_pause_pressed)
	controls.erase_pressed.connect(_on_erase_pressed)
	controls.reset_pressed.connect(_on_reset_pressed)

func load_level(path: String):
	if current_level:
		current_level.queue_free()
	
	var scene = load(path).instantiate()
	level_container.add_child(scene)
	current_level = scene

	# Wait one frame to ensure anchors are added to the tree
	await get_tree().process_frame
	bridge_builder.refresh_anchors()   # 👈 Now anchors will connect properly

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
	load_level("res://levels/Level1.tscn")
	_erase_user_supports()
	
	for beam in get_tree().get_nodes_in_group("user_supports"):
		if beam.has_method("set_build_mode"):
			beam.set_build_mode(true)
	for anchor in get_tree().get_nodes_in_group("anchors"):
		if anchor.has_method("set_build_mode"):
			anchor.set_build_mode(true)
