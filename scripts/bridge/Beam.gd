extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var anchor_a: StaticBody2D
var anchor_b: StaticBody2D

func setup(a: StaticBody2D, b: StaticBody2D):
	anchor_a = a
	anchor_b = b
	_update_transform()

func _update_transform():
	if not (anchor_a and anchor_b):
		return

	var pos_a = anchor_a.global_position
	var pos_b = anchor_b.global_position

	# Place beam in the middle
	global_position = (pos_a + pos_b) * 0.5
	rotation = (pos_b - pos_a).angle()

	var length = pos_a.distance_to(pos_b)

	sprite.scale.x = length / sprite.texture.get_width()

	var margin := 8.0  # shrink on both ends (pixels)
	var collision_length = max(length - margin, 0.0)

	var rect := RectangleShape2D.new()
	rect.size = Vector2(collision_length, sprite.texture.get_height())
	collision.shape = rect
