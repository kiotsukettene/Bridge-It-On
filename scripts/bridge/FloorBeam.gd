extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func setup(a: Vector2, b: Vector2):
	# Position between points
	global_position = (a + b) * 0.5
	rotation = (b - a).angle()

	var length = a.distance_to(b)
	sprite.scale.x = length / sprite.texture.get_width()

	# Update collision shape
	var rect := RectangleShape2D.new()
	rect.size = Vector2(length, sprite.texture.get_height())
	collision.shape = rect
