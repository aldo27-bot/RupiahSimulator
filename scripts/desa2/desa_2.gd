extends Node2D

@onready var cart = $Cart
@onready var popup = $TravelPopup
@onready var warung = $Buildings/Warung
@onready var warung_popup = $WarungPopup


func _ready():

	SaveManager.apply_loaded_data()
	popup.accepted.connect(_go_to_desa1)
	popup.cancelled.connect(_cancel)

	# Signal dari Warung Popup
	warung_popup.buy_pressed.connect(_on_buy_warung)
	warung_popup.claim_pressed.connect(_on_claim_profit)
	warung_popup.close_pressed.connect(_on_close_popup)

	print(BusinessData.businesses)


func _input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			if _mouse_on_cart():
				print("Gerobak diklik")
				popup.show_popup()

			elif _mouse_on_warung():

				print("Warung diklik")

				if BusinessData.businesses["warung"]["owned"]:

					print("Popup Klaim")
					warung_popup.show_claim_popup()

				else:

					print("Popup Beli")
					warung_popup.show_buy_popup()


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


func _go_to_desa1():

	get_tree().change_scene_to_file(
		"res://scenes/menu/desa.tscn"
	)


func _cancel():

	pass
