extends Node2D

@export var cell_size: int = 32
@export var grid_size: Vector2 = Vector2(2000, 2000) # covers large area
@export var line_color: Color = Color(1, 1, 1, 0.1)  # faint white
@export var line_width: float = 1.0

func _ready():
	z_index = -1  # make sure it's behind everything
	queue_redraw()

func _draw():
	for x in range(0, int(grid_size.x), cell_size):
		draw_line(Vector2(x, 0), Vector2(x, grid_size.y), line_color, line_width)

	for y in range(0, int(grid_size.y), cell_size):
		draw_line(Vector2(0, y), Vector2(grid_size.x, y), line_color, line_width)
