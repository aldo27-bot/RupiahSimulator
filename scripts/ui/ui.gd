extends CanvasLayer

@onready var inventory_panel = $InventoryPanel
@onready var item_list = $InventoryPanel/ItemList
@onready var cart_list = $InventoryPanel/CartList

@onready var inventory_button = $InventoryButton
@onready var buy_button = $InventoryPanel/BuyButton
@onready var sell_button = $InventoryPanel/SellButton

@onready var money_label = $MoneyLabel
@onready var rupiah_label = $RupiahLabel


# ======================
# STATE
# ======================
var selected_item := "kopi"

var cart = {
	"kopi": 0,
	"beras": 0,
	"gula": 0
}


# ======================
# READY
# ======================
func _ready():
	inventory_panel.visible = false

	inventory_button.pressed.connect(_on_open_inventory)
	buy_button.pressed.connect(_on_buy_cart)
	sell_button.pressed.connect(_on_sell_cart)

	Economy.uang_berubah.connect(_on_money_changed)
	Market.stok_berubah.connect(_on_stock_changed)

	update_hud()
	refresh_items()
	refresh_cart()


# ======================
# SIGNAL
# ======================
func _on_money_changed(_v):
	update_hud()


func _on_stock_changed(_i, _s):
	refresh_items()
	refresh_cart()
	update_hud()


# ======================
# HUD
# ======================
func update_hud():
	money_label.text = "Rp " + str(Economy.uang)
	rupiah_label.text = "Rupiah: " + str(Economy.rupiah_strength)


# ======================
# OPEN PANEL
# ======================
func _on_open_inventory():
	inventory_panel.visible = true
	refresh_items()
	refresh_cart()


# ======================
# ITEM LIST
# ======================
func refresh_items():
	for c in item_list.get_children():
		c.queue_free()

	for item_name in Market.items.keys():
		var row = HBoxContainer.new()

		var btn = Button.new()
		btn.text = item_name.capitalize()
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		btn.pressed.connect(func():
			selected_item = item_name
		)

		var stock = Label.new()
		stock.text = "Stok: " + str(Market.items[item_name]["stok"])
		stock.custom_minimum_size.x = 90

		var plus = Button.new()
		plus.text = "+"
		plus.pressed.connect(func():
			cart[item_name] += 1
			refresh_cart()
		)

		var minus = Button.new()
		minus.text = "-"
		minus.pressed.connect(func():
			if cart[item_name] > 0:
				cart[item_name] -= 1
				refresh_cart()
		)

		row.add_child(btn)
		row.add_child(stock)
		row.add_child(minus)
		row.add_child(plus)

		item_list.add_child(row)


# ======================
# CART TOTAL (BUY PRICE)
# ======================
func get_cart_total() -> int:
	var total := 0
	for item_name in cart.keys():
		total += Supplier.get_price(item_name) * cart[item_name]
	return total


# ======================
# CART UI
# ======================
func refresh_cart():
	for c in cart_list.get_children():
		c.queue_free()

	var total := 0

	for item_name in cart.keys():
		if cart[item_name] > 0:
			var label = Label.new()
			label.text = item_name.capitalize() + " x" + str(cart[item_name])
			cart_list.add_child(label)

			total += Supplier.get_price(item_name) * cart[item_name]

	var total_label = Label.new()
	total_label.text = "TOTAL BELI: Rp " + str(total)
	cart_list.add_child(total_label)


# ======================
# BUY SYSTEM
# ======================
func _on_buy_cart():
	for item_name in cart.keys():
		var qty = cart[item_name]

		if qty > 0:
			Market.beli_dari_supplier(
				item_name,
				qty,
				Supplier.get_price(item_name)
			)

			cart[item_name] = 0

	refresh_items()
	refresh_cart()
	update_hud()

	show_notify("✅ Berhasil membeli barang")


# ======================
# SELL SYSTEM (DINAMIS)
# ======================
func _on_sell_cart():
	var income := 0

	for item_name in cart.keys():
		var qty = cart[item_name]

		if qty > 0:
			var stock = Market.items[item_name]["stok"]

			if qty > stock:
				qty = stock

			for i in range(qty):
				income += Market.jual(item_name)

			cart[item_name] = 0

	refresh_items()
	refresh_cart()
	update_hud()

	show_notify("💰 Berhasil menjual +Rp " + str(income))


# ======================
# NOTIFICATION SYSTEM
# ======================
func show_notify(text):
	var label = $InventoryPanel/NotificationLabel

	if label == null:
		return

	label.text = text
	label.visible = true

	await get_tree().create_timer(2).timeout
	label.visible = false
