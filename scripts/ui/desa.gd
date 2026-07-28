extends Node2D

@onready var bgm = $BGM

@onready var horse_cart = $HorseCart
@onready var popup = $TravelPopup

@onready var house_popup = $CanvasLayer/Popup3
@onready var bank_popup = $CanvasLayer/Popup

var waypoints = []
var jalan_markers = []


func _ready() -> void:

	bgm.volume_db = -15
	bgm.play()

	house_popup.visible = false
	bank_popup.visible = false

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


func _on_btn_tutup_pressed() -> void:

	house_popup.visible = false
	bank_popup.visible = false


func _on_house_input_event(viewport, event, shape_idx) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		house_popup.visible = true


func _on_bank_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		bank_popup.visible = true
