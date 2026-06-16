extends Camera2D

@onready var background = $"../Background"

var min_zoom = 1.0
var max_zoom = 3.0

var drag_camera = false
var last_mouse_pos = Vector2.ZERO

func _ready():

	var screen_size = get_viewport_rect().size

	var bg_size = background.texture.get_size()
	bg_size *= background.scale

	var zoom_x = screen_size.x / bg_size.x
	var zoom_y = screen_size.y / bg_size.y

	min_zoom = max(zoom_x, zoom_y)

	zoom = Vector2(min_zoom, min_zoom)

	limit_left = 0
	limit_top = 0
	limit_right = int(bg_size.x)
	limit_bottom = int(bg_size.y)

func _unhandled_input(event):

	# Mouse Button
	if event is InputEventMouseButton:

		# Zoom In
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:

			zoom *= 0.9

			if zoom.x < min_zoom:
				zoom = Vector2(min_zoom, min_zoom)

		# Zoom Out
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:

			zoom *= 1.1

			if zoom.x > max_zoom:
				zoom = Vector2(max_zoom, max_zoom)

		# Drag Kamera
		elif event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				drag_camera = true
			else:
				drag_camera = false

	# Geser Kamera
	elif event is InputEventMouseMotion and drag_camera:

		global_position -= event.relative / zoom.x
		
func _process(delta):

	var speed = 500
	var dir = Vector2.ZERO

	if Input.is_key_pressed(KEY_A):
		dir.x -= 1

	if Input.is_key_pressed(KEY_D):
		dir.x += 1

	if Input.is_key_pressed(KEY_W):
		dir.y -= 1

	if Input.is_key_pressed(KEY_S):
		dir.y += 1

	if dir != Vector2.ZERO:
		global_position += dir.normalized() * speed * delta
		
