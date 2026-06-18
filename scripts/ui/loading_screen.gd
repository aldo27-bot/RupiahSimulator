extends Control

@onready var progress_bar = $ProgressBar
@onready var coin = $Coin

var target_scene := ""
var flip_time := 0.0

func _ready():

	progress_bar.min_value = 0
	progress_bar.max_value = 100

	# Titik putar koin di tengah
	await get_tree().process_frame
	coin.pivot_offset = coin.size / 2

func _process(delta):

	# Efek koin berputar horizontal
	flip_time += delta * 6.0

	coin.scale.x = cos(flip_time)

func start_loading(scene_path:String, text_loading:String) -> void:

	target_scene = scene_path

	await get_tree().process_frame
	await get_tree().process_frame
	await load_animation()

func load_animation() -> void:

	print("Loading dimulai")

	for i in range(0, 101, 2):

		progress_bar.value = i

		# Koin mengikuti progress bar
		var ratio = float(i) / 100.0

		coin.position = Vector2(
			lerp(
				progress_bar.position.x,
				progress_bar.position.x + progress_bar.size.x,
				ratio
			),
			progress_bar.position.y - 40
		)

		await get_tree().create_timer(0.025).timeout

	print("GAME LOADED")

	var error = get_tree().change_scene_to_file(target_scene)

	if error == OK:
		queue_free()
