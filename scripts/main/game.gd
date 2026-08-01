extends Node2D

@onready var timer = $Timer
@onready var time = $TimeManager
@onready var market_timer = $MarketTimer

# ======================
# BACKGROUND
# ======================
@onready var background = $Background

# ======================
# Panel Hari & Jam
# ======================
@onready var hari_label = $CanvasLayer/TopBar/PanelHari/Value
@onready var jam_label = $CanvasLayer/TopBar/PanelJam/Value

# ======================
# Panel Market
# ======================
@onready var value = $CanvasLayer/TopBar/PanelMarket/Value
@onready var trend = $CanvasLayer/TopBar/PanelMarket/Trend
@onready var arrow = $CanvasLayer/TopBar/PanelMarket/IconTrend
@onready var trend_icon = $CanvasLayer/TopBar/PanelMarket/TrendIcon

# Panel Stok
@onready var stock = $CanvasLayer/Stock

# ======================
# Panel Saldo
# ======================
@onready var saldo_label = $CanvasLayer/TopBar/PanelSaldo/Value

# ======================
# Texture Market
# ======================
const ARROW_UP = preload("res://assets/warung/ui/Naik.png")
const ARROW_DOWN = preload("res://assets/warung/ui/Turun.png")

const TREND_UP = preload("res://assets/warung/ui/TrendNaik.png")
const TREND_DOWN = preload("res://assets/warung/ui/TrendTurun.png")


func _ready():
<<<<<<< HEAD

	await get_tree().process_frame

	resize_background()

=======
>>>>>>> c4aa59b (supplier done)
	timer.wait_time = 1.0
	time.update_waktu_device()

	# --- KODE BARU: Menyambungkan uang ke tampilan ---
	PlayerData.saldo_berubah.connect(update_saldo_ui)
	update_saldo_ui(PlayerData.coin) # Tampilkan saldo 100.000 saat pertama buka
	# -------------------------------------------------

	update_ui()
	update_market_ui()
	timer.start()

	stock.hide()


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


func update_ui():

	hari_label.text = str(time.hari)

	jam_label.text = "%02d:%02d" % [
		time.jam,
		time.menit
	]


func _on_timer_timeout():

	time.update_waktu_device()

	update_ui()


func update_market_ui():
	# Karena market sekarang unik per item, kita ambil contoh data dari item pertama (misal: base_price 120 / Beras)
	# untuk merepresentasikan status di panel atas utama.
	var sample_trend_data = Market.get_item_trend_data(120)

	if sample_trend_data.trend == Market.Trend.NAIK:

		arrow.texture = ARROW_UP
		trend_icon.texture = TREND_UP

		value.text = "+" + str(sample_trend_data.persen) + "%"

		value.add_theme_color_override(
			"font_color",
			Color("35A853")
		)

		trend.text = "NAIK"

		trend.add_theme_color_override(
			"font_color",
			Color("35A853")
		)

	else:

		arrow.texture = ARROW_DOWN
		trend_icon.texture = TREND_DOWN

		value.text = "-" + str(sample_trend_data.persen) + "%"

		value.add_theme_color_override(
			"font_color",
			Color("E53935")
		)

		trend.text = "TURUN"

		trend.add_theme_color_override(
			"font_color",
			Color("E53935")
		)

# Fungsi ini akan otomatis dipanggil jika saldo berubah
func update_saldo_ui(saldo_baru: int):
	saldo_label.text = str(saldo_baru)

func _on_market_timer_timeout():

	Market.update_market()

	update_market_ui()


# Button Supplier
func _on_btn_supplier_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/supplier.tscn")


# Button Stok
func _on_btn_stok_pressed() -> void:
	stock.show()


# Button Laporan
func _on_btn_laporan_pressed() -> void:
	pass


# Button Target
func _on_btn_target_pressed() -> void:
<<<<<<< HEAD
	pass
=======
	get_tree().change_scene_to_file("res://scenes/main/misi.tscn")
>>>>>>> c4aa59b (supplier done)
