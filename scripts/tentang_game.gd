extends Control

func _on_keluar_pressed():
	$keluar.scale = Vector2.ONE

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		$keluar,
		"scale",
		Vector2(0.9, 0.9),
		0.08
	)

	tween.tween_property(
		$keluar,
		"scale",
		Vector2.ONE,
		0.08
	)

	await tween.finished

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
