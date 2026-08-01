extends Node2D

@onready var timer = $Timer
@onready var time = $TimeManager
@onready var market_timer = $MarketTimer

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
# Panah besar
@onready var arrow = $CanvasLayer/TopBar/PanelMarket/IconTrend
# Grafik kecil
@onready var trend_icon = $CanvasLayer/TopBar/PanelMarket/TrendIcon

# ======================
# Texture Market
# ======================
const ARROW_UP = preload("res://assets/warung/ui/Naik.png")
const ARROW_DOWN = preload("res://assets/warung/ui/Turun.png")

const TREND_UP = preload("res://assets/warung/ui/TrendNaik.png")
const TREND_DOWN = preload("res://assets/warung/ui/TrendTurun.png")


func _ready():

	timer.wait_time = 1.0

	time.update_waktu_device()

	update_ui()

	update_market_ui()

	timer.start()

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

	if Market.trend == Market.Trend.NAIK:

		arrow.texture = ARROW_UP
		trend_icon.texture = TREND_UP

		value.text = "+" + str(Market.persen) + "%"

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

		value.text = "-" + str(Market.persen) + "%"

		value.add_theme_color_override(
			"font_color",
			Color("E53935")
		)

		trend.text = "TURUN"

		trend.add_theme_color_override(
			"font_color",
			Color("E53935")
		)


func _on_market_timer_timeout():

	Market.update_market()

	update_market_ui()

# Button Supplier
func _on_btn_supplier_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/supplier.tscn")

# Button Stok
func _on_btn_stok_pressed() -> void:
	pass # Replace with function body.

# Button Laporan
func _on_btn_laporan_pressed() -> void:
	pass # Replace with function body.

# Button Target
func _on_btn_target_pressed() -> void:
	pass # Replace with function body.
