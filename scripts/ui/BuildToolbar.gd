extends CanvasLayer

signal material_selected(material_type: String)

@onready var container = $Container
@onready var wood_button: TextureButton = $Container/WoodButton
@onready var metal_button: TextureButton = $Container/MetalButton
@onready var background: Sprite2D = $Container/Background

var current_material: String = "wood"

func _ready():

	wood_button.pressed.connect(_on_wood_selected)
	metal_button.pressed.connect(_on_metal_selected)
	

	_update_button_state()

func _on_wood_selected():
	current_material = "wood"
	emit_signal("material_selected", "wood")
	_update_button_state()

func _on_metal_selected():
	current_material = "metal"
	emit_signal("material_selected", "metal")
	_update_button_state()

func _update_button_state():

	if current_material == "wood":
		wood_button.modulate = Color(1, 1, 1)        
		metal_button.modulate = Color(0.6, 0.6, 0.6)  
	else:
		wood_button.modulate = Color(0.6, 0.6, 0.6)
		metal_button.modulate = Color(1, 1, 1)
