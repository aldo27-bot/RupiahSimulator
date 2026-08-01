extends Control

const ICON_NAIK = preload("res://assets/warung/ui/Naik.png")
const ICON_TURUN = preload("res://assets/warung/ui/Turun.png")

var item_id := ""
var base_price := 0
var item_level_required := 1
var player_level := 1

var current_amount := 0

@onready var icon_rect = $Icon
@onready var nama_label = $NamaLabel
@onready var price_label = $PriceLabel
@onready var trend_label = $TrendLabel
@onready var trend_icon = $TrendIcon
@onready var stock_label = $StockLabel
@onready var coin_icon = $CoinIcon

@onready var lock_icon = $LockIcon
@onready var locked_buy_button = $LockedBuyButton

@onready var minus_button = $MinusButton
@onready var amount_label = $AmountLabel
@onready var plus_button = $PlusButton

var bg_overlay : ColorRect


func _ready():

	if !Market.market_updated.is_connected(refresh_item_ui):
		Market.market_updated.connect(refresh_item_ui)

	if !ItemDatabase.stock_changed.is_connected(refresh_item_ui):
		ItemDatabase.stock_changed.connect(refresh_item_ui)

	bg_overlay = ColorRect.new()
	bg_overlay.color = Color(0.5,0.5,0.5,0.3)
	bg_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg_overlay.visible = false

	add_child(bg_overlay)
	move_child(bg_overlay,0)

	if !minus_button.pressed.is_connected(_on_minus_pressed):
		minus_button.pressed.connect(_on_minus_pressed)

	if !plus_button.pressed.is_connected(_on_plus_pressed):
		plus_button.pressed.connect(_on_plus_pressed)

	amount_label.text = "0"


func setup(data:Dictionary,current_player_level:int):

	item_id = data["id"]
	base_price = data["base_price"]
	item_level_required = data["unlock_level"]
	player_level = current_player_level

	nama_label.text = data["name"]
	icon_rect.texture = data["icon"]

	refresh_item_ui()


func refresh_item_ui():

	if player_level < item_level_required:

		setup_locked_ui()
		return

	setup_unlocked_ui()

	price_label.text = str(
		Market.get_price(
			item_id,
			base_price
		)
	)

	var trend_data = Market.get_item_trend_data(
		item_id,
		base_price
	)

	if trend_data.trend == Market.Trend.NAIK:

		trend_label.text = "+" + str(trend_data.persen) + "%"
		trend_label.add_theme_color_override("font_color",Color.GREEN)
		trend_icon.texture = ICON_NAIK

	else:

		trend_label.text = "-" + str(trend_data.persen) + "%"
		trend_label.add_theme_color_override("font_color",Color.RED)
		trend_icon.texture = ICON_TURUN

	stock_label.text = str(ItemDatabase.get_stock(item_id))


func setup_locked_ui():

	price_label.visible = false
	coin_icon.visible = false
	trend_icon.visible = false
	stock_label.visible = false

	minus_button.visible = false
	amount_label.visible = false
	plus_button.visible = false

	locked_buy_button.visible = true

	lock_icon.visible = true

	trend_label.visible = true
	trend_label.text = "Akan terbuka di Level %d" % item_level_required

	bg_overlay.visible = true


func setup_unlocked_ui():

	price_label.visible = true
	coin_icon.visible = true
	trend_icon.visible = true
	trend_label.visible = true
	stock_label.visible = true

	minus_button.visible = true
	amount_label.visible = true
	plus_button.visible = true

	locked_buy_button.visible = false
	lock_icon.visible = false

	bg_overlay.visible = false

	stock_label.text = str(ItemDatabase.get_stock(item_id))


func get_selected_amount()->int:
	return current_amount


func get_item_price()->int:
	return Market.get_price(
		item_id,
		base_price
	)


func _on_plus_pressed():

	var max_beli := 20

	if current_amount >= max_beli:
		return

	current_amount += 1
	amount_label.text = str(current_amount)

	notif_supplier_update()


func _on_minus_pressed():

	if current_amount <= 0:
		return

	current_amount -= 1
	amount_label.text = str(current_amount)

	notif_supplier_update()


func notif_supplier_update():

	var supplier = get_tree().get_first_node_in_group("supplier_group")

	if supplier and supplier.has_method("refresh_bottom_panel"):
		supplier.refresh_bottom_panel()


#========================================================
# DIPANGGIL SAAT TOMBOL BELI DITEKAN
#========================================================

func beli_barang():

	if current_amount <= 0:
		return

	ItemDatabase.add_stock(item_id,current_amount)

	current_amount = 0
	amount_label.text = "0"

	refresh_item_ui()

	notif_supplier_update()
