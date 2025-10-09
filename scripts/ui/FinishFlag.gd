extends Area2D

signal level_complete(vehicle_name: String)

@export var flag_name: String = "GoalFlag"

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("[Flag] Ready:", flag_name)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("vehicles"):
		print("🏁 Vehicle reached finish:", body.name)
		emit_signal("level_complete", body.name)

		if has_node("Sprite2D"):
			$Sprite2D.modulate = Color(0.6, 1.0, 0.6)  # turn light green
