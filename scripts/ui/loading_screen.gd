extends Control

@onready var progress_bar = $ProgressBar
@onready var percent_label = $PercentLabel
@onready var loading_text = $LoadingText

var target_scene := ""

func _ready():

	progress_bar.min_value = 0
	progress_bar.max_value = 100

func start_loading(scene_path:String, text_loading:String) -> void:

	target_scene = scene_path
	loading_text.text = text_loading

	await get_tree().process_frame
	await get_tree().process_frame
	await load_animation()


func load_animation() -> void:

	print("Loading dimulai")

	for i in range(0, 101, 2):

		progress_bar.value = i

		print(i)

		await get_tree().create_timer(0.03).timeout

	print("GAME LOADED")

	get_tree().change_scene_to_file(target_scene)
