extends Node2D

@onready var bgm = $BGM

@onready var horse_cart = $HorseCart
@onready var popup = $TravelPopup

var waypoints = []
var jalan_markers = []

func _ready():

	bgm.play()

	popup.accepted.connect(_go_to_desa2)
	popup.cancelled.connect(_cancel)

func _input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			if _mouse_on_cart():

				print("Kereta diklik")

				popup.show_popup()

func _mouse_on_cart() -> bool:

	var tex = horse_cart.texture

	if tex == null:
		return false

	var size = tex.get_size() * horse_cart.scale

	var rect = Rect2(
		horse_cart.global_position - size / 2,
		size
	)

	return rect.has_point(get_global_mouse_position())

func _go_to_desa2():

	get_tree().change_scene_to_file(
		"res://scenes/desa2/desa_2.tscn"
	)

func _cancel():

	pass
