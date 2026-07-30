extends Node2D

@onready var bgm = $BGM

@onready var cart = $Cart
@onready var popup = $TravelPopup
@onready var warung = $Buildings/Warung
@onready var warung_popup = $WarungPopup

@onready var balai_desa = $Buildings/balaidesa
@onready var balai_popup = $CanvasLayer/PopupBalai/PopupImage
@onready var balai_btn = $CanvasLayer/PopupBalai/BtnTutup

@onready var rumah_sultan = $Buildings/rumahsultan
@onready var rumah_sultan_popup = $CanvasLayer/PopupRumahSultan/PopupImage
@onready var rumah_sultan_btn = $CanvasLayer/PopupRumahSultan/BtnTutup

@onready var rumah_biasa = $Buildings/rumahbiasa
@onready var rumah_biasa_popup = $CanvasLayer/PopupRumahBiasa/PopupImage
@onready var rumah_biasa_btn = $CanvasLayer/PopupRumahBiasa/BtnTutup

@onready var bank = $Buildings/bank
@onready var bank_popup = $CanvasLayer/Popup

@onready var popup_kembali = $CanvasLayer/PopupKembali

var popup_open := false

func _ready():
	
	bgm.volume_db = 2
	if !bgm.playing:
		bgm.play()

	SaveManager.apply_loaded_data()
	popup.accepted.connect(_go_to_desa1)
	popup.cancelled.connect(_cancel)

	# Signal dari Warung Popup
	warung_popup.buy_pressed.connect(_on_buy_warung)
	warung_popup.claim_pressed.connect(_on_claim_profit)
	warung_popup.close_pressed.connect(_on_close_popup)
	bank_popup.popup_closed.connect(_on_bank_popup_closed)

	print(BusinessData.businesses)
	
	balai_popup.visible = false
	balai_btn.visible = false
	
	rumah_sultan_popup.visible = false
	rumah_sultan_btn.visible = false
	
	rumah_biasa_popup.visible = false
	rumah_biasa_btn.visible = false
	
	bank_popup.visible = false

func _input(event):

	if popup_open:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		# Gerobak
		if _mouse_on_cart():

			print("Gerobak diklik")
			popup.show_popup()

		# Warung
		elif _mouse_on_warung():

			print("Warung diklik")

			lock_camera()

			if BusinessData.businesses["warung"]["owned"]:

				print("Popup Klaim")
				warung_popup.show_claim_popup()

			else:

				print("Popup Beli")
				warung_popup.show_buy_popup()

		# Balai Desa
		elif _mouse_on_balai():

			print("Balai Desa diklik")

			balai_popup.visible = true
			balai_btn.visible = true

			lock_camera()

		# Rumah Sultan
		elif _mouse_on_rumah_sultan():

			print("Rumah Sultan diklik")

			rumah_sultan_popup.visible = true
			rumah_sultan_btn.visible = true

			lock_camera()

		# Rumah Biasa
		elif _mouse_on_rumah_biasa():

			print("Rumah Biasa diklik")

			rumah_biasa_popup.visible = true
			rumah_biasa_btn.visible = true

			lock_camera()

		# Bank
		elif _mouse_on_bank():

			print("Bank diklik")

			lock_camera()
			bank_popup.show_popup()

func _mouse_on_cart() -> bool:

	var tex = cart.texture

	if tex == null:
		return false

	var size = tex.get_size() * cart.scale

	var rect = Rect2(
		cart.global_position - size / 2,
		size
	)

	return rect.has_point(get_global_mouse_position())

func _mouse_on_warung() -> bool:

	var sprite = warung.get_node("Sprite2D")

	if sprite.texture == null:
		return false

	var size = sprite.texture.get_size() * sprite.scale

	var rect = Rect2(
		sprite.global_position - size / 2,
		size
	)

	return rect.has_point(get_global_mouse_position())

# ====================================================
# BELI WARUNG
# ====================================================

func _on_buy_warung():

	var warung_data = BusinessData.businesses["warung"]
	
	print("Uang player =", Economy.uang)
	print("Harga warung =", warung_data["purchase_price"])

	if Economy.uang >= warung_data["purchase_price"]:

		Economy.kurang_uang(
			warung_data["purchase_price"]
		)

		warung_data["owned"] = true

		warung_data["last_collect_time"] = Time.get_unix_time_from_system()
		SaveManager.save_business()
		print("Warung berhasil dibeli")
		warung_popup.hide_popup()

	else:

		print("Uang tidak cukup")

# ====================================================
# CLAIM PROFIT
# ====================================================

func _on_claim_profit():

	print("Claim Profit")

# ====================================================
# CLOSE POPUP
# ====================================================

func _on_close_popup():

	warung_popup.hide_popup()
	unlock_camera()

func _go_to_desa1():

	get_tree().change_scene_to_file(
		"res://scenes/menu/desa.tscn"
	)

func _cancel():

	pass
	
#===========================================

#fungsi popup balaidesa
func _mouse_on_balai() -> bool:

	if balai_desa.texture == null:
		return false

	var size = balai_desa.texture.get_size() * balai_desa.scale

	var rect = Rect2(
		balai_desa.global_position - size / 2,
		size
	)

	return rect.has_point(get_global_mouse_position())
	
#fungsi popup rumah sultan
func _mouse_on_rumah_sultan() -> bool:

	if rumah_sultan.texture == null:
		return false

	var size = rumah_sultan.texture.get_size() * rumah_sultan.scale

	var rect = Rect2(
		rumah_sultan.global_position - size / 2,
		size
	)

	return rect.has_point(get_global_mouse_position())
	
# fungsi popup rumah biasa
func _mouse_on_rumah_biasa() -> bool:

	if rumah_biasa.texture == null:
		return false

	var size = rumah_biasa.texture.get_size() * rumah_biasa.scale

	var rect = Rect2(
		rumah_biasa.global_position - size / 2,
		size
	)

	return rect.has_point(get_global_mouse_position())
	
#fungsi popup bank
func _mouse_on_bank() -> bool:

	if bank.texture == null:
		return false

	var size = bank.texture.get_size() * bank.scale

	var rect = Rect2(
		bank.global_position - size / 2,
		size
	)

	return rect.has_point(get_global_mouse_position())
	
func _on_btn_tutup_pressed() -> void:

	balai_popup.visible = false
	balai_btn.visible = false
	unlock_camera()
	
func _on_btn_tutup_rumah_sultan_pressed() -> void:

	rumah_sultan_popup.visible = false
	rumah_sultan_btn.visible = false
	unlock_camera()
	
func _on_btn_tutup_rumah_biasa_pressed() -> void:

	rumah_biasa_popup.visible = false
	rumah_biasa_btn.visible = false
	unlock_camera()
	
#fungsi kunci kamera
func lock_camera():

	var cam = get_viewport().get_camera_2d()

	if cam:
		cam.camera_locked = true

	popup_open = true


func unlock_camera():

	var cam = get_viewport().get_camera_2d()

	if cam:
		cam.camera_locked = false

	popup_open = false

func _on_bank_popup_closed():

	unlock_camera()


func _on_kembali_pressed():
	popup_kembali.buka()
