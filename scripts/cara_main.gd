extends Control

var halaman = 1
var current_tween: Tween

@onready var p1 = $Caramain0
@onready var p2 = $Caramain1
@onready var p3 = $Caramain2
@onready var p4 = $Caramain3

@onready var btn_lanjut = $lanjut
@onready var btn_kembali = $kembali

func _ready():
	update_halaman()

func update_halaman():
	p1.visible = (halaman == 1)
	p2.visible = (halaman == 2)
	p3.visible = (halaman == 3)
	p4.visible = (halaman == 4)

	btn_kembali.visible = halaman > 1
	btn_lanjut.visible = halaman < 4

func animate_button(btn: Control, target_scale: Vector2, duration: float):
	if current_tween:
		current_tween.kill()

	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_BACK)
	current_tween.set_ease(Tween.EASE_OUT)

	current_tween.tween_property(
		btn,
		"scale",
		target_scale,
		duration
	)

# =====================
# LANJUT
# =====================
func _on_lanjut_pressed():
	btn_lanjut.scale = Vector2.ONE

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		btn_lanjut,
		"scale",
		Vector2(0.9, 0.9),
		0.08
	)

	tween.tween_property(
		btn_lanjut,
		"scale",
		Vector2.ONE,
		0.08
	)

	await tween.finished

	if halaman < 4:
		halaman += 1
		update_halaman()
# =====================
# KEMBALI
# =====================

func _on_kembali_pressed():
	btn_kembali.scale = Vector2.ONE

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		btn_kembali,
		"scale",
		Vector2(0.9, 0.9),
		0.08
	)

	tween.tween_property(
		btn_kembali,
		"scale",
		Vector2.ONE,
		0.08
	)

	await tween.finished

	if halaman > 1:
		halaman -= 1
		update_halaman()
# =====================
# KELUAR
# =====================

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
