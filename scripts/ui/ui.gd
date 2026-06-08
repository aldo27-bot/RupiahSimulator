extends CanvasLayer

@onready var inventory_panel = $InventoryPanel
@onready var item_list = $InventoryPanel/ItemList
@onready var cart_list = $InventoryPanel/CartList

@onready var inventory_button = $BottomPanel/MarginContainer/HBoxContainer/InventoryButton
@onready var buy_button = $InventoryPanel/BuyButton
@onready var sell_button = $InventoryPanel/SellButton
@onready var close_button = $InventoryPanel/CloseButton

@onready var money_label = $BottomPanel/MarginContainer/HBoxContainer/MoneyFrame/CenterContainer/MoneyLabel
@onready var rupiah_label = $BottomPanel/MarginContainer/HBoxContainer/RupiahLabel
@onready var level_label = $LevelLabel
@onready var background = $Background
# CUSTOMER
@onready var customer = $Customer
# AUDIO
@onready var sfx_player = $SFXPlayer

# ======================
# Format uang
# ======================
func format_rupiah(angka: int) -> String:
	var text = str(angka)
	var hasil = ""

	while text.length() > 3:
		hasil = "." + text.substr(text.length() - 3, 3) + hasil
		text = text.substr(0, text.length() - 3)

	hasil = text + hasil

	return "Rp " + hasil
	
# ======================
# STATE
# ======================
var selected_item := "kopi"
var level_toko := 1
var last_rupiah := 1.0
var customer_spawn_position = Vector2(30, 350)

var cart = {
	"kopi": 0,
	"beras": 0,
	"gula": 0,
}


# ======================
# READY
# ======================
func _ready():

	# ======================
	# SAVE DATA
	# ======================
	var save_data = SaveManager.load_game()

	if save_data != null:

		Economy.uang = save_data["uang"]

		Economy.rupiah_strength = save_data["rupiah"]

		Market.items = save_data["items"]
		
		cart = save_data["cart"]
			
		last_rupiah = Economy.rupiah_strength

	# ======================
	# UI
	# ======================
	inventory_panel.visible = false

	inventory_button.pressed.connect(_on_open_inventory)
	buy_button.pressed.connect(_on_buy_cart)
	sell_button.pressed.connect(_on_sell_cart)
	close_button.pressed.connect(_on_back_pressed)

	Economy.uang_berubah.connect(_on_money_changed)
	Market.stok_berubah.connect(_on_stock_changed)

	update_hud()
	refresh_items()
	refresh_cart()
	# POSISI AWAL CUSTOMER
	customer.position = customer_spawn_position
	# LEVEL DAN BACKGROUND AWAL
	update_level_label()
	update_background()
	
	if level_toko >= 2:
		Market.unlock_level_2_items()
	
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

	money_label.text = format_rupiah(Economy.uang)
	
	# LEVEL 2
	if Economy.uang >= 150000 and level_toko == 1:

		level_toko = 2

		Market.unlock_level_2_items()

		cart["mie"] = 0
		cart["susu"] = 0

		update_level_label()
		update_background()
		refresh_items()

		show_notify(
			"🎉 TOKO NAIK KE LEVEL 2!\nMie dan Susu sekarang tersedia!"
		)

	play_sfx("res://assets/audio/shopbell.ogg")

	rupiah_label.text = (
		"Rupiah: "
		+ str(snapped(Economy.rupiah_strength, 0.01))
	)
	
# ======================
# Level 
# ======================
func update_level_label():

	level_label.text = "🏪 LEVEL TOKO " + str(level_toko)

# ======================
# Update Background
# ======================
func update_background():

	if level_toko == 1:

		background.texture = load(
			"res://assets/images/rupiahbg.png"
		)

	elif level_toko == 2:

		background.texture = load(
			"res://assets/images/rupiahbg_lv2.png"
		)
# ======================
# OPEN PANEL
# ======================
func _on_open_inventory():

	play_sfx("res://assets/audio/button_click.ogg")
	inventory_panel.visible = true

	refresh_items()
	refresh_cart()


# ======================
# CLOSE PANEL
# ======================
func _on_back_pressed():

	play_sfx("res://assets/audio/button_click.ogg")
	inventory_panel.visible = false


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

		# ======================
		# PRICE
		# ======================
		var base_price = Supplier.get_price(item_name)

		var dynamic_price = int(
			base_price * Economy.rupiah_strength
		)

		var price = Label.new()

		price.text = "Rp " + str(dynamic_price)

		price.custom_minimum_size.x = 100

		# ======================
		# STOCK
		# ======================
		var stock = Label.new()

		stock.text = (
			"Stok: "
			+ str(int(Market.items[item_name]["stok"]))
		)

		stock.custom_minimum_size.x = 90

		# ======================
		# PLUS BUTTON
		# ======================
		var plus = Button.new()

		plus.text = "+"

		plus.pressed.connect(func():

			cart[item_name] += 1

			refresh_cart()
		)

		# ======================
		# MINUS BUTTON
		# ======================
		var minus = Button.new()

		minus.text = "-"

		minus.pressed.connect(func():

			if cart[item_name] > 0:

				cart[item_name] -= 1

				refresh_cart()
		)

		row.add_child(btn)
		row.add_child(price)
		row.add_child(stock)
		row.add_child(minus)
		row.add_child(plus)

		item_list.add_child(row)


# ======================
# CART TOTAL
# ======================
func get_cart_total() -> int:

	var total := 0

	for item_name in cart.keys():

		var dynamic_price = int(
			Supplier.get_price(item_name)
			* Economy.rupiah_strength
		)

		total += dynamic_price * cart[item_name]

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

			label.text = (
				item_name.capitalize()
				+ " x"
				+ str(cart[item_name])
			)

			cart_list.add_child(label)

			var dynamic_price = int(
				Supplier.get_price(item_name)
				* Economy.rupiah_strength
			)

			total += dynamic_price * cart[item_name]

	var total_label = Label.new()

	total_label.text = (
		"TOTAL BELI: Rp "
		+ str(total)
	)

	cart_list.add_child(total_label)


# ======================
# BUY SYSTEM
# ======================
func _on_buy_cart():

	play_sfx("res://assets/audio/button_click.ogg")
	for item_name in cart.keys():

		var qty = cart[item_name]

		if qty > 0:

			Market.beli_dari_supplier(
				item_name,
				qty,
				int(
					Supplier.get_price(item_name)
					* Economy.rupiah_strength
				)
			)

			cart[item_name] = 0

	update_hud()
	update_level_label()
	
	refresh_items()
	refresh_cart()

	SaveManager.save_game(
	cart,
	level_toko
)

	show_notify("✅ Berhasil membeli barang")


# ======================
# SELL SYSTEM CUSTOMER
# ======================
func _on_sell_cart():

	var income := 0

	# ======================
	# CEK CUSTOMER
	# ======================
	if customer == null:

		show_notify("❌ Tidak ada customer")

		return

	var request_item = customer.request_item

	# ======================
	# CEK CART
	# ======================
	if cart[request_item] <= 0:

		show_notify(
			"❌ Customer meminta "
			+ request_item.capitalize()
		)

		return

	# ======================
	# CEK STOK
	# ======================
	var stock = Market.items[request_item]["stok"]

	if stock <= 0:

		show_notify("❌ Stok habis")

		return

	# ======================
	# JUAL ITEM
	# ======================
	income += Market.jual(request_item)
	play_sfx("res://assets/audio/coin.ogg")

	# kurangi cart
	cart[request_item] -= 1

	# ======================
	# UPDATE UI
	# ======================
	refresh_items()
	refresh_cart()
	update_hud()

	SaveManager.save_game(
	cart,
	level_toko
	)

	# ======================
	# CUSTOMER PERGI
	# ======================
	customer.queue_free()

	show_notify(
		"💰 Berhasil menjual "
		+ request_item.capitalize()
		+ " +Rp "
		+ str(income)
	)

	# ======================
	# SPAWN CUSTOMER BARU
	# ======================
	await get_tree().create_timer(2).timeout

	var customer_scene = preload(
		"res://scenes/customer/customer.tscn"
	)

	var new_customer = customer_scene.instantiate()
	play_sfx("res://assets/audio/shopbell.ogg")

	new_customer.position = customer_spawn_position
	play_sfx("res://assets/audio/shopbell.ogg")

	add_child(new_customer)

	customer = new_customer

# ======================
# AUDIO SYSTEM
# ======================
func play_sfx(sound_path: String):

	if not ResourceLoader.exists(sound_path):
		print("Audio tidak ditemukan: ", sound_path)
		return

	sfx_player.stream = load(sound_path)
	sfx_player.play()
	
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


# ======================
# RUPIAH SYSTEM
# ======================
func _on_timer_timeout():

	last_rupiah = Economy.rupiah_strength

	var change = randf_range(-0.05, 0.05)

	Economy.rupiah_strength += change

	Economy.rupiah_strength = clamp(
		Economy.rupiah_strength,
		0.5,
		1.5
	)

	var arrow = ""

	if Economy.rupiah_strength > last_rupiah:

		arrow = " ↑"

	elif Economy.rupiah_strength < last_rupiah:

		arrow = " ↓"

	rupiah_label.text = (
		"Rupiah: "
		+ str(snapped(Economy.rupiah_strength, 0.01))
		+ arrow
	)

	# ======================
	# MARKET COLOR
	# ======================
	if Economy.rupiah_strength > last_rupiah:

		rupiah_label.modulate = Color.GREEN

	elif Economy.rupiah_strength < last_rupiah:

		rupiah_label.modulate = Color.RED

	else:

		rupiah_label.modulate = Color.WHITE

	# ======================
	# POP ANIMATION
	# ======================
	var tween = create_tween()

	rupiah_label.scale = Vector2(1.2, 1.2)

	tween.tween_property(
		rupiah_label,
		"scale",
		Vector2.ONE,
		0.2
	)

	refresh_items()
	refresh_cart()

	print("Rupiah:", Economy.rupiah_strength)
