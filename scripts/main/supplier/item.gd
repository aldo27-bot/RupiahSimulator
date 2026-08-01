extends Control

@onready var icon: TextureRect = $Icon
@onready var nama_label: Label = $NamaLabel
@onready var price_label: Label = $PriceLabel
@onready var stock_label: Label = $StockLabel

@onready var trend_icon: TextureRect = $TrendIcon
@onready var trend_label: Label = $TrendLabel
@onready var amount_label: Label = $AmountLabel

var buy_amount := 0
var base_price := 0

func _ready():
	# Hubungkan signal hanya sekali
	if !Market.market_updated.is_connected(update_market):
		Market.market_updated.connect(update_market)

func setup(data):
	icon.texture = data["icon"]
	nama_label.text = data["name"]
	base_price = data["price"]
	stock_label.text = str(data["stock"])

	update_market()

func update_market():

	var harga_baru = Market.get_price(base_price)

	price_label.text = str(harga_baru)

	if Market.trend == Market.Trend.NAIK:
		trend_icon.texture = preload("res://assets/warung/ui/Naik.png")
		trend_label.text = "+" + str(Market.persen) + "%"
		trend_label.modulate = Color.GREEN
	else:
		trend_icon.texture = preload("res://assets/warung/ui/Turun.png")
		trend_label.text = "-" + str(Market.persen) + "%"
		trend_label.modulate = Color.RED


func _on_plus_button_pressed() -> void:
	buy_amount += 1
	amount_label.text = str(buy_amount)


func _on_minus_button_pressed() -> void:
	if buy_amount > 0:
		buy_amount -= 1
		amount_label.text = str(buy_amount)
