extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var agent = $NavigationAgent2D

var speed = 50.0

func _ready():
	randomize()

	# Tunggu navigation system siap
	await get_tree().physics_frame

	setup_agent()

	print("NPC global:", global_position)
	print("Sprite global:", sprite.global_position)

	sprite.position = Vector2.ZERO

func setup_agent():
	choose_destination()

	print("Nav Map:", agent.get_navigation_map())
	print("Agent Connected:", agent.get_navigation_map() != RID())

func _physics_process(delta):

	# Navigation belum siap
	if agent.get_navigation_map() == RID():
		return

	# Sampai tujuan
	if agent.is_navigation_finished():
		sprite.stop()
		velocity = Vector2.ZERO

		choose_destination()
		return

	# Ambil titik path berikutnya
	var next_pos = agent.get_next_path_position()
	var direction = next_pos - global_position

	if direction.length() > 5:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO

	update_animation(direction)

	move_and_slide()

func update_animation(direction):

	if direction.length() < 0.1:
		sprite.stop()
		return

	if abs(direction.x) > abs(direction.y):
		sprite.play("walk_side")

		# Jika sprite asli menghadap kiri
		sprite.flip_h = direction.x > 0

	else:
		if direction.y > 0:
			sprite.play("walk_down")
		else:
			sprite.play("walk_up")

func choose_destination():

	var nav_map = agent.get_navigation_map()

	if nav_map == RID():
		return

	# Cari titik acak
	var random_point = Vector2(
		randf_range(0, 1280),
		randf_range(0, 720)
	)

	# Cari titik terdekat yang valid di navmesh
	var valid_point = NavigationServer2D.map_get_closest_point(
		nav_map,
		random_point
	)

	agent.target_position = valid_point

	print("Target:", valid_point)
