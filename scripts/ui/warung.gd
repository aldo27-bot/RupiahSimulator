extends Area2D

func _ready():
	print("Warung siap")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_tree().change_scene_to_file("res://scenes/main/main.tscn")
