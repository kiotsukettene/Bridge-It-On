extends StaticBody2D

signal start_drag(anchor: StaticBody2D)

func _ready():
	if not is_in_group("anchors"):
		add_to_group("anchors")

	collision_layer = 1
	collision_mask = 0

	print("Anchor ready:", name, " layer=", collision_layer, " mask=", collision_mask)

	input_event.connect(_on_input_event)


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("start_drag", self)
