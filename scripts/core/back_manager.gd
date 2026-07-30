extends Node

var back_pressed := false

func _process(_delta):

	if Input.is_action_just_pressed("ui_cancel"):
		handle_back()


func handle_back():

	if back_pressed:
		get_tree().quit()
		return

	back_pressed = true

	await get_tree().create_timer(2.0).timeout

	back_pressed = false
