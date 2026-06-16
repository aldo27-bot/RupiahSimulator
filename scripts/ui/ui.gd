extends CanvasLayer

@onready var inventory_panel = $InventoryPanel
@onready var item_list = $InventoryPanel/ItemList
@onready var cart_list = $InventoryPanel/CartList

@onready var inventory_button = $InventoryFrame/InventoryButton
@onready var buy_button = $InventoryPanel/BuyButton
@onready var sell_button = $InventoryPanel/SellButton
@onready var close_button = $InventoryPanel/CloseButton

@onready var gudang_button = $GudangFrame/GudangButton
@onready var gudang_panel = $GudangPanel
@onready var gudang_item_list = $GudangPanel/ScrollContainer/GudangItemList
@onready var gudang_close_button = $GudangPanel/CloseButton

@onready var money_label = $MoneyFrame/CenterContainer/MoneyLabel
@onready var rupiah_label = $RupiahLabel
@onready var level_label = $LevelLabel
@onready var background = $Background
# CUSTOMER
@onready var customer = $Customer
@onready var spawn_point = $SpawnPoint
@onready var cashier_point = $CashierPoint
@onready var exit_point = $ExitPoint
# AUDIO
@onready var sfx_player = $SFXPlayer

@onready var item_card_scene = preload("res://scenes/menu/item_card.tscn")

@onready var button_desa = $ButtonDesa

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

		if not Market.items.has("mie"):
			Market.items["mie"] = {
				"stok": 0,
				"base_price": 3500
			}

		if not Market.items.has("susu"):
			Market.items["susu"] = {
				"stok": 0,
				"base_price": 8000
			}
		
		cart = save_data["cart"]
			
		last_rupiah = Economy.rupiah_strength

	# ======================
	# UI
	# ======================
	inventory_panel.visible = false
	gudang_panel.visible = false

	inventory_button.pressed.connect(_on_open_inventory)
	buy_button.pressed.connect(_on_buy_cart)
	sell_button.pressed.connect(_on_sell_cart)
	close_button.pressed.connect(_on_back_pressed)
	button_desa.pressed.connect(_on_btn_desa_pressed)
	
	gudang_button.pressed.connect(_on_open_gudang)
	gudang_close_button.pressed.connect(_on_close_gudang)

	Economy.uang_berubah.connect(_on_money_changed)
	Market.stok_berubah.connect(_on_stock_changed)

	update_hud()
	refresh_items()
	refresh_cart()
# POSISI AWAL CUSTOMER
	customer.global_position = spawn_point.global_position
	customer.get_node("Sprite2D").flip_h = false
	customer.target_position = cashier_point.global_position
	customer.reached_target.connect(
		_on_customer_reached
)
	# LEVEL DAN BACKGROUND AWAL
	update_level_label()
	update_background()
	
	if level_toko >= 2:
		Market.unlock_level_2_items()
	
func _on_customer_reached():

	if customer == null:
		return

	if customer.is_leaving:

		customer.queue_free()

		await get_tree().create_timer(1).timeout

		spawn_new_customer()

	else:

		customer.random_request()
# ======================
# SIGNAL
# ======================
func _on_money_changed(_v):

	update_hud()


func _on_stock_changed(_i, _s):

	refresh_items()
	refresh_cart()
	refresh_gudang()
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
		refresh_gudang()

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
			"res://assets/images/bg_game_baru.png"
		)

	elif level_toko == 2:

		background.texture = load(
			"res://assets/images/bg_game_baru.png"
		)
# ======================
# OPEN Inventory
# ======================
func _on_open_inventory():

	play_sfx("res://assets/audio/button_click.ogg")
	inventory_panel.visible = !inventory_panel.visible

	if inventory_panel.visible:
		gudang_panel.visible=false
		refresh_items()
		refresh_cart()

# ======================
# CLOSE Inventory
# ======================
func _on_back_pressed():

	play_sfx("res://assets/audio/button_click.ogg")
	inventory_panel.visible = false
	
# ======================
# OPEN Gudang
# ======================
func _on_open_gudang():

	play_sfx("res://assets/audio/button_click.ogg")

	gudang_panel.visible = !gudang_panel.visible

	if gudang_panel.visible:
		inventory_panel.visible = false
		refresh_gudang()

# ======================
# CLOSE Gudang
# ======================
func _on_close_gudang():

	play_sfx("res://assets/audio/button_click.ogg")

	gudang_panel.visible = false

# ======================
# ITEM LIST
# ======================
func refresh_items():

	for c in item_list.get_children():
		c.queue_free()

	for item_name in Market.items.keys():
		if item_name == "mie" and level_toko < 2:
			continue
		if item_name == "susu" and level_toko < 2:
			continue

		var card = item_card_scene.instantiate()


		# ======================
		# PRICE DINAMIS
		# ======================
		var base_price = Supplier.get_price(item_name)

		var dynamic_price = int(
			base_price * Economy.rupiah_strength
		)

		# ======================
		# ICON
		# ======================
		var icon = null

		match item_name:
			"beras":
				icon = preload("res://assets/images/iconberas.png")
			"gula":
				icon = preload("res://assets/images/icongula.jpg")
			"kopi":
				icon = preload("res://assets/images/iconkopi.png")

		# ======================
		# SET KE CARD
		# ======================
		card.set_item(
			item_name.capitalize(),
			dynamic_price,
			icon,
			Market.items[item_name]["stok"]
		)

		# ======================
		# KLIK CARD → TAMBAH CART
		# ======================
		card.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed:
				cart[item_name] += 1
				refresh_cart()
		)

		item_list.add_child(card)

# ======================
# Refresh Gudang
# ======================
func refresh_gudang():

	for child in gudang_item_list.get_children():
		child.queue_free()

	for item_name in Market.items.keys():

		var card = item_card_scene.instantiate()

		var stock = Market.items[item_name]["stok"]

		var dynamic_price = int(
			Supplier.get_price(item_name)
			* Economy.rupiah_strength
		)

		var icon = null

		match item_name:

			"beras":
				icon = preload(
					"res://assets/images/iconberas.png"
				)

			"gula":
				icon = preload(
					"res://assets/images/icongula.jpg"
				)

			"kopi":
				icon = preload(
					"res://assets/images/iconkopi.png"
				)

		card.set_item(
			item_name.capitalize(),
			dynamic_price,
			icon,
			stock
		)

		if item_name == "mie" and level_toko < 2:

			card.modulate = Color(0.4, 0.4, 0.4)

			card.get_node("VBoxContainer/Harga").text = \
				"🔒 Level 2"

		if item_name == "susu" and level_toko < 2:

			card.modulate = Color(0.4, 0.4, 0.4)

			card.get_node("VBoxContainer/Harga").text = \
				"🔒 Level 2"

		gudang_item_list.add_child(card)
		
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
	refresh_gudang()
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
	customer.request_label.hide()
	customer.is_leaving = true
	customer.get_node("Sprite2D").flip_h = true
	customer.target_position = exit_point.global_position

	show_notify(
		"💰 Berhasil menjual "
		+ request_item.capitalize()
		+ " +Rp "
		+ str(income)
	)

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
	refresh_gudang()

	print("Rupiah:", Economy.rupiah_strength)
	
func spawn_new_customer():

	var customer_scene = preload(
		"res://scenes/customer/customer.tscn"
	)

	var new_customer = customer_scene.instantiate()

	new_customer.global_position = spawn_point.global_position

	new_customer.get_node("Sprite2D").flip_h = false

	new_customer.target_position = cashier_point.global_position

	add_child(new_customer)

	move_child(
		new_customer,
		background.get_index() + 1
	)

	customer = new_customer

	customer.reached_target.connect(
		_on_customer_reached
	)

	play_sfx(
		"res://assets/audio/shopbell.ogg"
	)

func _on_btn_desa_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/desa.tscn")
	
