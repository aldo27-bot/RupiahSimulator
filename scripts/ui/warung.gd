extends Area2D

@onready var popup = $"../CanvasLayer/Popup2"

func _ready() -> void:
	popup.visible = false


func _input_event(viewport, event, shape_idx) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		# Jangan buka lagi jika popup sudah tampil
		if popup.visible:
			return

		popup.visible = true


func _on_btn_masuk_pressed() -> void:

	# Tutup popup terlebih dahulu
	popup.visible = false

	# Tunggu 1 frame agar perubahan tampil
	await get_tree().process_frame

	var loading = preload(
		"res://scenes/menu/loading_screen.tscn"
	).instantiate()

	get_tree().root.add_child(loading)

	loading.start_loading(
		"res://scenes/main/game.tscn",
		"Masuk Warung..."
	)


func _on_btn_tutup_pressed() -> void:

	popup.visible = false
