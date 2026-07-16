extends Camera2D

@export var speed := 500.0
@export var background: Sprite2D

var min_x
var max_x
var min_y
var max_y

func _ready():

	var map_size = background.texture.get_size()

	# Jika Sprite2D memakai Centered = ON
	var half_map = map_size / 2.0

	# Ukuran viewport
	var viewport_size = get_viewport_rect().size
	var half_view = viewport_size / 2.0

	min_x = background.global_position.x - half_map.x + half_view.x
	max_x = background.global_position.x + half_map.x - half_view.x

	min_y = background.global_position.y - half_map.y + half_view.y
	max_y = background.global_position.y + half_map.y - half_view.y


func _process(delta):

	var dir := Vector2.ZERO

	if Input.is_key_pressed(KEY_A):
		dir.x -= 1

	if Input.is_key_pressed(KEY_D):
		dir.x += 1

	if Input.is_key_pressed(KEY_W):
		dir.y -= 1

	if Input.is_key_pressed(KEY_S):
		dir.y += 1

	position += dir.normalized() * speed * delta

	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
