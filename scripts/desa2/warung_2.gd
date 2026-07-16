extends Area2D

func _ready():
	input_pickable = true
	print("Warung siap")

#func _input_event(_viewport, event, _shape_idx):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("Warung diklik")

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Warung diklik")
