extends Camera2D

@onready var background = $"../Background"

var min_zoom = 1.0
var max_zoom = 3.0

# Drag PC
var drag_camera = false

# Touch Android
var touches = {}
var last_distance = 0.0


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

	# ===================================================
	# PC : Mouse Wheel Zoom
	# ===================================================
	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:

			zoom *= 0.9

			zoom.x = clamp(zoom.x, min_zoom, max_zoom)
			zoom.y = zoom.x

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:

			zoom *= 1.1

			zoom.x = clamp(zoom.x, min_zoom, max_zoom)
			zoom.y = zoom.x

		elif event.button_index == MOUSE_BUTTON_LEFT:

			drag_camera = event.pressed


	# ===================================================
	# PC : Drag Camera
	# ===================================================
	elif event is InputEventMouseMotion:

		if drag_camera:

			global_position -= event.relative / zoom.x


	# ===================================================
	# Android : Touch Start / End
	# ===================================================
	elif event is InputEventScreenTouch:

		if event.pressed:
			touches[event.index] = event.position
		else:
			touches.erase(event.index)

			if touches.size() < 2:
				last_distance = 0.0


	# ===================================================
	# Android : Drag & Pinch Zoom
	# ===================================================
	elif event is InputEventScreenDrag:

		touches[event.index] = event.position

		# Geser kamera dengan satu jari
		if touches.size() == 1:

			global_position -= event.relative / zoom.x

		# Zoom dengan dua jari
		elif touches.size() == 2:

			var points = touches.values()

			var distance = points[0].distance_to(points[1])

			if last_distance > 0:

				var delta = distance - last_distance

				if abs(delta) > 2:

					var zoom_factor = 1.0 - delta * 0.0015

					zoom *= zoom_factor

					zoom.x = clamp(zoom.x, min_zoom, max_zoom)
					zoom.y = zoom.x

			last_distance = distance


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
