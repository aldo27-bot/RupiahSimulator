extends Area2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

			var loading = preload(
				"res://scenes/menu/loading_screen.tscn"
			).instantiate()

			get_tree().root.add_child(loading)

			loading.start_loading(
				"res://scenes/main/main.tscn",
				"Masuk Warung..."
			)
