extends Node2D

@onready var timer = $Timer
@onready var time = $TimeManager
@onready var market_timer = $MarketTimer

# CUSTOMER
@onready var customer = $Customer
@onready var spawn_point = $SpawnPoint
@onready var cashier_point = $CashierPoint

var customer_wait_time = 2.0

# BACKGROUND
@onready var background = $Background

# PANEL HARI JAM
@onready var hari_label = $CanvasLayer/TopBar/PanelHari/Value
@onready var jam_label = $CanvasLayer/TopBar/PanelJam/Value

# MARKET
@onready var value = $CanvasLayer/TopBar/PanelMarket/Value
@onready var trend = $CanvasLayer/TopBar/PanelMarket/Trend
@onready var arrow = $CanvasLayer/TopBar/PanelMarket/IconTrend
@onready var trend_icon = $CanvasLayer/TopBar/PanelMarket/TrendIcon

# STOCK
@onready var stock = $CanvasLayer/Stock

# SALDO
@onready var saldo_label = $CanvasLayer/TopBar/PanelSaldo/Value

# LAYANI
@onready var layani_popup = $LayaniPopup
@onready var tombol_layani = $Layani

const ARROW_UP = preload("res://assets/warung/ui/Naik.png")
const ARROW_DOWN = preload("res://assets/warung/ui/Turun.png")
const TREND_UP = preload("res://assets/warung/ui/TrendNaik.png")
const TREND_DOWN = preload("res://assets/warung/ui/TrendTurun.png")


func _ready():

	SaveManager.apply_loaded_data()

	layani_popup.popup.visible = false

	customer.global_position = spawn_point.global_position

	await get_tree().physics_frame

	customer.set_target(
		cashier_point.global_position
	)

	customer.reached_target.connect(
		_on_customer_reached
	)

	customer.finished.connect(
		_on_customer_finished
	)

	await get_tree().process_frame

	resize_background()

	timer.wait_time = 1.0

	time.update_waktu_device()

	PlayerData.saldo_berubah.connect(update_saldo_ui)

	update_saldo_ui(PlayerData.coin)

	update_ui()
	update_market_ui()

	timer.start()

	stock.hide()



# ======================
# CUSTOMER
# ======================

func _on_customer_reached():

	print("Customer sampai kasir")

	customer.random_request()



func _on_customer_finished():

	print("Customer selesai")

	await get_tree().create_timer(customer_wait_time).timeout

	if customer:

		customer.reset_customer()

		customer.global_position = spawn_point.global_position

		customer.set_target(
			cashier_point.global_position
		)



# ======================
# BACKGROUND
# ======================

func resize_background():

	if background.texture == null:
		return

	var viewport_size = get_viewport().get_visible_rect().size
	var tex_size = background.texture.get_size()

	var scale_factor = max(
		viewport_size.x / tex_size.x,
		viewport_size.y / tex_size.y
	)

	background.scale = Vector2(scale_factor, scale_factor)
	background.position = viewport_size / 2



# ======================
# UI
# ======================

func update_ui():

	hari_label.text = str(time.hari)

	jam_label.text = "%02d:%02d" % [
		time.jam,
		time.menit
	]


func _on_timer_timeout():

	time.update_waktu_device()

	update_ui()



# ======================
# MARKET
# ======================

func update_market_ui():

	var data = Market.get_item_trend_data(
		"beras",
		ItemDatabase.get_item("beras")["base_price"]
	)

	if data.trend == Market.Trend.NAIK:

		arrow.texture = ARROW_UP
		trend_icon.texture = TREND_UP

		value.text = "+" + str(data.persen) + "%"

		trend.text = "NAIK"

		value.add_theme_color_override(
			"font_color",
			Color("35A853")
		)

		trend.add_theme_color_override(
			"font_color",
			Color("35A853")
		)

	else:

		arrow.texture = ARROW_DOWN
		trend_icon.texture = TREND_DOWN

		value.text = "-" + str(data.persen) + "%"

		trend.text = "TURUN"

		value.add_theme_color_override(
			"font_color",
			Color("E53935")
		)

		trend.add_theme_color_override(
			"font_color",
			Color("E53935")
		)



func update_saldo_ui(saldo_baru:int):

	saldo_label.text = str(saldo_baru)



func _on_market_timer_timeout():

	Market.update_market()

	update_market_ui()



# ======================
# BUTTON
# ======================

func _on_btn_supplier_pressed():

	get_tree().change_scene_to_file(
		"res://scenes/main/supplier.tscn"
	)



func _on_btn_stok_pressed():

	stock.show()



func _on_btn_laporan_pressed():

	pass



func _on_btn_target_pressed():

	get_tree().change_scene_to_file(
		"res://scenes/main/misi.tscn"
	)



func _on_layani_pressed():

	print("BUTTON LAYANI DIPENCET")

	layani_popup.buka_popup(customer)


func _on_tolak_pressed() -> void:

	print("BUTTON TOLAK DIPENCET")

	if customer:

		customer.customer_rejected()
