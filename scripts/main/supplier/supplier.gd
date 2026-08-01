extends Control

@onready var item_container = $ItemContainer
@onready var total_jenis_label = $BottomBar/TotalJenisLabel
@onready var total_stok_label = $BottomBar/TotalStokLabel
@onready var buy_button = $BottomBar/BuyButton
@onready var coin_label = $CoinPanel/CoinLabel

const BTN_ABU = preload("res://assets/warung/supplier/abu.png")
const BTN_HIJAU = preload("res://assets/warung/supplier/hijau.png")
const FONT_POPPINS = preload("res://assets/font/Nunito-Bold.ttf")

var item_scene = preload("res://scenes/main/supplier/item.tscn")

var player_level_sekarang := 1


func _ready():

	add_to_group("supplier_group")

	var save_data = SaveManager.load_game()

	if save_data:
		player_level_sekarang = save_data.get("level_toko", 1)

	load_items()

	if total_jenis_label:
		total_jenis_label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
		total_jenis_label.add_theme_font_override("font", FONT_POPPINS)

	if total_stok_label:
		total_stok_label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
		total_stok_label.add_theme_font_override("font", FONT_POPPINS)

	PlayerData.saldo_berubah.connect(update_coin_display)
	update_coin_display(PlayerData.coin)

	if !ItemDatabase.stock_changed.is_connected(refresh_bottom_panel):
		ItemDatabase.stock_changed.connect(refresh_bottom_panel)

	if buy_button:

		buy_button.mouse_filter = Control.MOUSE_FILTER_STOP

		if !buy_button.pressed.is_connected(_on_buy_button_pressed):
			buy_button.pressed.connect(_on_buy_button_pressed)

	refresh_bottom_panel()



# ==========================
# LOAD ITEM
# ==========================

func load_items():

	for child in item_container.get_children():
		child.queue_free()

	var daftar_item = ItemDatabase.get_unlocked_items(player_level_sekarang)

	var index := 0

	for data in daftar_item:

		var row = item_scene.instantiate()

		item_container.add_child(row)

		row.position = Vector2(0, index * 62)

		row.setup(data, player_level_sekarang)

		index += 1



# ==========================
# COIN
# ==========================

func update_coin_display(saldo_baru:int):

	if coin_label:
		coin_label.text = str(saldo_baru)



# ==========================
# REFRESH PANEL
# ==========================

func refresh_bottom_panel():

	var total_dipilih := 0

	for row in item_container.get_children():

		if row.has_method("get_selected_amount"):
			total_dipilih += row.get_selected_amount()


	total_jenis_label.text = str(
		ItemDatabase.get_unlocked_items(player_level_sekarang).size()
	) + " / " + str(ItemDatabase.items.size())


	# Stok milik pemain
	total_stok_label.text = str(
		ItemDatabase.get_player_total_stock()
	)


	if buy_button:

		var label = buy_button.get_node_or_null("Label")

		if label:
			label.text = "BELI (" + str(total_dipilih) + ")"


		buy_button.disabled = total_dipilih <= 0
		buy_button.texture_normal = BTN_HIJAU if total_dipilih > 0 else BTN_ABU



# ==========================
# BELI BARANG
# ==========================

func _on_buy_button_pressed():

	var total_harga := 0

	for row in item_container.get_children():

		if row.has_method("get_selected_amount") and row.has_method("get_item_price"):

			total_harga += row.get_selected_amount() * row.get_item_price()


	if total_harga <= 0:
		return


	if !PlayerData.kurangi_coin(total_harga):

		print("Coin tidak cukup")
		return


	# Tambah stok pemain
	for row in item_container.get_children():

		if row.has_method("beli_barang"):
			row.beli_barang()


	# Simpan stok terbaru
	SaveManager.save_item_database()


	# Refresh tampilan
	load_items()
	refresh_bottom_panel()

	SaveManager.save_current({}, player_level_sekarang)
	
	print("Pembelian supplier berhasil")

# ==========================
# BACK
# ==========================

func _on_btn_back_pressed():

	get_tree().change_scene_to_file(
		"res://scenes/main/game.tscn"
	)
