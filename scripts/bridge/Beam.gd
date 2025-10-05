extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var anchor_a: RigidBody2D
var anchor_b: RigidBody2D
var build_mode := true
var build_material := "wood"

# Fixed thickness by material (only affects Y)
const MATERIAL_THICKNESS := {
	"wood": 0.127,
	"metal": 0.2
}

const FIXED_SCALE_X := 1.0  # keep texture width 1:1, don't compress/stretch

const TEXTURES := {
	"wood": preload("res://assets/sprites/environment/Wood_Texture.png"),
	"metal": preload("res://assets/sprites/environment/Metal_Texture.png")
}

func _ready():
	if not is_in_group("user_supports"):
		add_to_group("user_supports")

	set_build_mode(true)
	apply_build_material()


func setup(a: RigidBody2D, b: RigidBody2D, mat_type: String = "wood"):
	anchor_a = a
	anchor_b = b
	build_material = mat_type
	apply_build_material()
	_update_transform()


func apply_build_material():
	var tex: Texture2D = TEXTURES.get(build_material, TEXTURES["wood"])
	sprite.texture = tex
	sprite.scale = Vector2(FIXED_SCALE_X, MATERIAL_THICKNESS.get(build_material, 0.127))


func _update_transform():
	if not (anchor_a and anchor_b):
		return

	var pos_a = anchor_a.global_position
	var pos_b = anchor_b.global_position

	global_position = (pos_a + pos_b) * 0.5
	rotation = (pos_b - pos_a).angle()

	var length = pos_a.distance_to(pos_b)
	var height = sprite.texture.get_height() * sprite.scale.y

	# Instead of scaling texture horizontally, resize collision + sprite region
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, length / sprite.scale.x, sprite.texture.get_height())

	var rect := RectangleShape2D.new()
	rect.size = Vector2(length, height)
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
