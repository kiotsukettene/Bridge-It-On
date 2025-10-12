extends CanvasLayer

@onready var panel = $Panel
@onready var reset_button: TextureButton = $Panel/ResetButton
@onready var levels_button: TextureButton = $Panel/LevelsButton
@onready var home_button: TextureButton = $Panel/HomeButton
@onready var result_label: Label = $Panel/ResultLabel
@onready var material_type: Label = $Panel/MaterialType
@onready var nodes: Label = $Panel/Nodes
@onready var stiffness: Label = $Panel/Stiffness
@onready var beams: Label = $Panel/Beams
@onready var bend: Label = $Panel/Bend

func _ready() -> void:
	visible = false
	panel.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 10
	print("FEAAnalyser hidden on start.")

	if is_instance_valid(reset_button):
		reset_button.pressed.connect(_on_reset_pressed)
	if is_instance_valid(levels_button):
		levels_button.pressed.connect(_on_levels_pressed)
	if is_instance_valid(home_button):
		home_button.pressed.connect(_on_home_pressed)

func show_results(level_name: String, peak_deflection: float, vehicle_name: String, total_stiffness: float, beam_count: int, materials: String, floor_beam_count: int, average_deflection: float) -> void:
	panel.visible = true
	visible = true

	print("🔎 FEA Analysis for", level_name)
	print("→ Vehicle:", vehicle_name)
	print("→ Peak Deflection: %.2f px" % peak_deflection)
	print("→ Beams:", beam_count)
	print("→ Materials:", materials)
	print("→ Total Stiffness: %.2f" % total_stiffness)
	var total_beams = beam_count + floor_beam_count
	var total_nodes = total_beams * 2
	beams.text = str(beam_count)
	stiffness.text = "%.2f" % total_stiffness
	bend.text = "%.2f" % peak_deflection
	material_type.text =  materials
	nodes.text = "%d" % total_nodes
	result_label.text = "%.2f" % average_deflection


func _on_reset_pressed() -> void:
	print("🔁 Reset pressed — reloading level.")
	hide_popup()
	get_tree().paused = false
	var game_scene = get_tree().current_scene
	if game_scene and game_scene.has_method("_on_reset_pressed"):
		game_scene._on_reset_pressed()  
	else:
		var path = Global.selected_level_path
		if path == "" or path == null:
			path = "res://levels/Level1.tscn"
		get_tree().change_scene_to_file("res://scenes/main/Game.tscn")

func _on_levels_pressed() -> void:
	hide_popup()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/LevelSelect.tscn")

func _on_home_pressed() -> void:
	hide_popup()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")


func hide_popup() -> void:
	panel.visible = false
	visible = false
