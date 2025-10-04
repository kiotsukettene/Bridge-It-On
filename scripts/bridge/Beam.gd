extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var anchor_a: RigidBody2D
var anchor_b: RigidBody2D
var build_mode := true   # True = frozen until Play pressed

func _ready():
	if not is_in_group("user_supports"):
		add_to_group("user_supports")

	set_build_mode(true)


func setup(a: RigidBody2D, b: RigidBody2D):
	anchor_a = a
	anchor_b = b
	_update_transform()


func _update_transform():
	if not (anchor_a and anchor_b):
		return

	var pos_a = anchor_a.global_position
	var pos_b = anchor_b.global_position


	global_position = (pos_a + pos_b) * 0.5
	rotation = (pos_b - pos_a).angle()

	var length = pos_a.distance_to(pos_b)
	sprite.scale.x = length / sprite.texture.get_width()

	var margin := 8.0  
	var collision_length = max(length - margin, 0.0)

	var rect := RectangleShape2D.new()
	rect.size = Vector2(collision_length, sprite.texture.get_height())
	collision.shape = rect


func set_build_mode(active: bool):
	build_mode = active
	if active:
		sleeping = true
		gravity_scale = 0.0
		lock_rotation = true
	else:
		sleeping = false
		gravity_scale = 1.0
		lock_rotation = false
