extends Control

var current_tween: Tween

func _ready():
	await get_tree().process_frame
	
	$PopupKeluar.hide()
	
	# Pivot di tengah card
	$MulaiContainer/CardMulai.pivot_offset = $MulaiContainer/CardMulai.size / 2
	$CaraMainContainer/CardCaraMain.pivot_offset = $CaraMainContainer/CardCaraMain.size / 2
	$PengaturanContainer/CardPengaturan.pivot_offset = $PengaturanContainer/CardPengaturan.size / 2
	$TentangGameContainer/CardTentangGame.pivot_offset = $TentangGameContainer/CardTentangGame.size / 2
	$PopupKeluar/PopupImage.pivot_offset = $PopupKeluar/PopupImage.size / 2
	$PopupKeluar/PopupImage/Iya.pivot_offset = $PopupKeluar/PopupImage/Iya.size / 2
	$PopupKeluar/PopupImage/Tidak.pivot_offset = $PopupKeluar/PopupImage/Tidak.size / 2


func animate_card(card: Control, target_scale: Vector2, duration: float):
	if current_tween:
		current_tween.kill()

	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_BACK)
	current_tween.set_ease(Tween.EASE_OUT)

	current_tween.tween_property(
		card,
		"scale",
		target_scale,
		duration
	)

# ==================================================
# BUTTON MULAI
# ==================================================

func _on_button_mulai_mouse_entered():
	animate_card(
		$MulaiContainer/CardMulai,
		Vector2(1.05, 1.05),
		0.15
	)

func _on_button_mulai_mouse_exited():
	animate_card(
		$MulaiContainer/CardMulai,
		Vector2.ONE,
		0.15
	)

func _on_button_mulai_button_down():
	animate_card(
		$MulaiContainer/CardMulai,
		Vector2(0.93, 0.93),
		0.08
	)

func _on_button_mulai_button_up():
	animate_card(
		$MulaiContainer/CardMulai,
		Vector2(1.05, 1.05),
		0.12
	)

func _on_button_mulai_pressed():
	animate_card(
		$MulaiContainer/CardMulai,
		Vector2(1.10, 1.10),
		0.10
	)

	await get_tree().create_timer(0.10).timeout

	get_tree().change_scene_to_file("res://scenes/menu/desa.tscn")


# ==================================================
# BUTTON CARA BERMAIN
# ==================================================

func _on_button_cara_main_mouse_entered():
	animate_card(
		$CaraMainContainer/CardCaraMain,
		Vector2(1.00, 1.00),
		0.15
	)

func _on_button_cara_main_mouse_exited():
	animate_card(
		$CaraMainContainer/CardCaraMain,
		Vector2.ONE,
		0.15
	)

func _on_button_cara_main_button_down():
	animate_card(
		$CaraMainContainer/CardCaraMain,
		Vector2(0.93, 0.93),
		0.08
	)

func _on_button_cara_main_button_up():
	animate_card(
		$CaraMainContainer/CardCaraMain,
		Vector2(1.05, 1.05),
		0.12
	)

func _on_button_cara_main_pressed():
	animate_card(
		$CaraMainContainer/CardCaraMain,
		Vector2(1.10, 1.10),
		0.10
	)

	await get_tree().create_timer(0.10).timeout

	get_tree().change_scene_to_file("res://scenes/cara_main.tscn")


# ==================================================
# BUTTON PENGATURAN
# ==================================================
func _on_button_pengaturan_mouse_entered() -> void:
	animate_card(
		$PengaturanContainer/CardPengaturan,
		Vector2(1.00, 1.00),
		0.15
	)


func _on_button_pengaturan_mouse_exited() -> void:
	animate_card(
		$PengaturanContainer/CardPengaturan,
		Vector2.ONE,
		0.15
	)


func _on_button_pengaturan_button_down() -> void:
	animate_card(
		$PengaturanContainer/CardPengaturan,
		Vector2(0.93, 0.93),
		0.08
	)


func _on_button_pengaturan_button_up() -> void:
	animate_card(
		$PengaturanContainer/CardPengaturan,
		Vector2(1.05, 1.05),
		0.12
	)


func _on_button_pengaturan_pressed() -> void:
	animate_card(
		$CaraMainContainer/CardCaraMain,
		Vector2(1.10, 1.10),
		0.10
	)

	await get_tree().create_timer(0.10).timeout

	get_tree().change_scene_to_file("res://scenes/pengaturan.tscn")
	

# ==================================================
# BUTTON TENTANG GAME
# ==================================================
func _on_button_tentang_game_mouse_entered() -> void:
	animate_card(
		$TentangGameContainer/CardTentangGame,
		Vector2(1.00, 1.00),
		0.15
	)


func _on_button_tentang_game_mouse_exited() -> void:
	animate_card(
		$TentangGameContainer/CardTentangGame,
		Vector2.ONE,
		0.15
	)


func _on_button_tentang_game_button_down() -> void:
	animate_card(
		$TentangGameContainer/CardTentangGame,
		Vector2(0.93, 0.93),
		0.08
	)


func _on_button_tentang_game_button_up() -> void:
	animate_card(
		$TentangGameContainer/CardTentangGame,
		Vector2(1.05, 1.05),
		0.12
	)


func _on_button_tentang_game_pressed() -> void:
	animate_card(
		$TentangGameContainer/CardTentangGame,
		Vector2(1.10, 1.10),
		0.10
	)

	await get_tree().create_timer(0.10).timeout

	get_tree().change_scene_to_file("res://scenes/tentang_game.tscn")
	


# ==================================================
# BUTTON KELUAR
# ==================================================
func _on_button_keluar_mouse_entered() -> void:
	animate_card(
		$KeluarContainer/CardKeluar,
		Vector2(1.00, 1.00),
		0.15
	)

func _on_button_keluar_mouse_exited() -> void:
	animate_card(
		$KeluarContainer/CardKeluar,
		Vector2.ONE,
		0.15
	)

func _on_button_keluar_button_down() -> void:
	animate_card(
		$KeluarContainer/CardKeluar,
		Vector2(0.93, 0.93),
		0.08
	)

func _on_button_keluar_button_up() -> void:
	animate_card(
		$KeluarContainer/CardKeluar,
		Vector2(1.05, 1.05),
		0.12
	)

func _on_button_keluar_pressed():

	$PopupKeluar.show()

	var tween = create_tween()
	tween.set_parallel()

	tween.tween_property(
		$BackgroundWarung,
		"modulate",
		Color(0.6, 0.6, 0.6, 0.588),
		0.2
	)

	$PopupKeluar/PopupImage.scale = Vector2(0.5,0.5)

	tween.tween_property(
		$PopupKeluar/PopupImage,
		"scale",
		Vector2.ONE,
		0.25
	)

# ==================================================
# ANIMASI POP UP IYA & TIDAK
# ==================================================
var popup_btn_tween: Tween

func animate_popup_btn(btn: Control, target_scale: Vector2, duration: float):
	if popup_btn_tween:
		popup_btn_tween.kill()

	popup_btn_tween = create_tween()

	popup_btn_tween.set_trans(Tween.TRANS_SINE)
	popup_btn_tween.set_ease(Tween.EASE_OUT)

	popup_btn_tween.tween_property(
		btn,
		"scale",
		target_scale,
		duration
	)

func _on_btn_tidak_button_down():
	var tween = create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		$PopupKeluar/PopupImage/Tidak,
		"scale:x",
		1.04,
		0.08
	)

	tween.tween_property(
		$PopupKeluar/PopupImage/Tidak,
		"scale:y",
		0.96,
		0.08
	)

func _on_btn_tidak_button_up():
	var tween = create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		$PopupKeluar/PopupImage/Tidak,
		"scale:x",
		0.98,
		0.06
	)

	tween.tween_property(
		$PopupKeluar/PopupImage/Tidak,
		"scale:y",
		1.02,
		0.06
	)

	await tween.finished

	var tween2 = create_tween()

	tween2.set_trans(Tween.TRANS_ELASTIC)
	tween2.set_ease(Tween.EASE_OUT)

	tween2.tween_property(
		$PopupKeluar/PopupImage/Tidak,
		"scale",
		Vector2.ONE,
		0.25
	)

func _on_btn_tidak_pressed():

	var tween = create_tween()
	tween.set_parallel()

	tween.tween_property(
		$BackgroundWarung,
		"modulate",
		Color.WHITE,
		0.2
	)

	tween.tween_property(
		$PopupKeluar/PopupImage,
		"scale",
		Vector2(0.5,0.5),
		0.2
	)

	await tween.finished

	$PopupKeluar.hide()

func _on_btn_iya_button_down():
	var tween = create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		$PopupKeluar/PopupImage/Iya,
		"scale:x",
		1.04,
		0.08
	)

	tween.tween_property(
		$PopupKeluar/PopupImage/Iya,
		"scale:y",
		0.96,
		0.08
	)

func _on_btn_iya_button_up():
	var tween = create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		$PopupKeluar/PopupImage/Iya,
		"scale:x",
		0.98,
		0.06
	)

	tween.tween_property(
		$PopupKeluar/PopupImage/Iya,
		"scale:y",
		1.02,
		0.06
	)

	await tween.finished

	var tween2 = create_tween()

	tween2.set_trans(Tween.TRANS_ELASTIC)
	tween2.set_ease(Tween.EASE_OUT)

	tween2.tween_property(
		$PopupKeluar/PopupImage/Iya,
		"scale",
		Vector2.ONE,
		0.25
	)

func _on_btn_iya_pressed() -> void:
	get_tree().quit()
