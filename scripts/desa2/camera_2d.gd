extends Camera2D

@export var speed := 500.0
@export var background: Sprite2D

var min_zoom := 1.0
var max_zoom := 3.0

# PC
var drag_camera := false

# Android
var touches := {}
var last_distance := 0.0

var camera_locked := false


func _ready():

	var screen_size = get_viewport_rect().size

	var bg_size = background.texture.get_size() * background.scale

	# Zoom minimum agar background memenuhi layar
	var zoom_x = screen_size.x / bg_size.x
	var zoom_y = screen_size.y / bg_size.y

	min_zoom = max(zoom_x, zoom_y)
	zoom = Vector2(min_zoom, min_zoom)

	# ==========================
	# LIMIT CAMERA
	# ==========================

	var half = bg_size / 2.0

	limit_left = int(background.global_position.x - half.x)
	limit_top = int(background.global_position.y - half.y)
	limit_right = int(background.global_position.x + half.x)
	limit_bottom = int(background.global_position.y + half.y)


func _unhandled_input(event):

	if camera_locked:
		return

	# ===================================================
	# PC : Mouse
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

		# Zoom dua jari
		elif touches.size() == 2:

			var points = touches.values()

			var distance = points[0].distance_to(points[1])

			if last_distance > 0.0:

				var delta = distance - last_distance

				if abs(delta) > 2.0:

					var zoom_factor = 1.0 - delta * 0.0015

					zoom *= zoom_factor

					zoom.x = clamp(zoom.x, min_zoom, max_zoom)
					zoom.y = zoom.x

			last_distance = distance


func _process(delta):

	if camera_locked:
		return

	var dir := Vector2.ZERO

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
