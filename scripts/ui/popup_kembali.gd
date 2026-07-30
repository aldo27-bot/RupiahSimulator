extends Control

@onready var btn_ya = $ya
@onready var btn_tidak = $Tidak

func _ready():
	visible = false

func buka():
	visible = true
	get_tree().paused = true

func tutup():
	visible = false
	get_tree().paused = false

func _on_ya_pressed():

	btn_ya.scale = Vector2.ONE

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		btn_ya,
		"scale",
		Vector2(0.9, 0.9),
		0.08
	)

	tween.tween_property(
		btn_ya,
		"scale",
		Vector2.ONE,
		0.08
	)

	await tween.finished

	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_tidak_pressed():

	btn_tidak.scale = Vector2.ONE

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		btn_tidak,
		"scale",
		Vector2(0.9, 0.9),
		0.08
	)

	tween.tween_property(
		btn_tidak,
		"scale",
		Vector2.ONE,
		0.08
	)

	await tween.finished

	tutup()
