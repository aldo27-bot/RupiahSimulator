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
var player_level_sekarang : int = 1 

var items = [
	{
		"name": "Beras",
		"icon": preload("res://assets/warung/supplier/beras.png"),
		"price": 12000,
		"stock": 10,
		"unlock_level": 1
	},
	{
		"name": "Minyak Goreng",
		"icon": preload("res://assets/warung/supplier/minyak.png"),
		"price": 15000,
		"stock": 6,
		"unlock_level": 1
	},
	{
		"name": "Telur",
		"icon": preload("res://assets/warung/supplier/telur.png"),
		"price": 25000,
		"stock": 8,
		"unlock_level": 1
	},
	{
		"name": "Gula",
		"icon": preload("res://assets/warung/supplier/gula.png"),
		"price": 150,
		"stock": 0,
		"unlock_level": 2 
	},
	{
		"name": "Tepung",
		"icon": preload("res://assets/warung/supplier/tepung.png"),
		"price": 110,
		"stock": 0,
		"unlock_level": 3 
	}
]

func _ready():
	player_level_sekarang = 1 
	
	# --- MASUKKAN KE GROUP AGAR MUDAH DITEMUKAN OLEH SCRIPT ITEM ---
	add_to_group("supplier_group")

	for i in range(items.size()):
		var row = item_scene.instantiate()
		item_container.add_child(row)
		row.position = Vector2(0, i * 62) 
		row.setup(items[i], player_level_sekarang)
		
	if total_jenis_label:
		total_jenis_label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
		total_jenis_label.add_theme_font_override("font", FONT_POPPINS)
		
	if total_stok_label:
		total_stok_label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
		total_stok_label.add_theme_font_override("font", FONT_POPPINS)

	PlayerData.saldo_berubah.connect(update_coin_display)
	update_coin_display(PlayerData.coin)

	# --- PAKSA KONEKSI & UKURAN TOMBOL BELI AGAR BISA DIKLIK ---
	if buy_button:
		buy_button.mouse_filter = Control.MOUSE_FILTER_STOP
		if not buy_button.pressed.is_connected(_on_buy_button_pressed):
			buy_button.pressed.connect(_on_buy_button_pressed)

	# --- PINDAHKAN KE SINI (PALING BAWAH) AGAR DIJALANKAN SETELAH SEMUA ITEM SIAP ---
	refresh_bottom_panel()

func update_coin_display(saldo_baru: int):
	if coin_label:
		coin_label.text = str(saldo_baru)

func refresh_bottom_panel():
	var total_jenis_terbuka = 0
	var total_stok_tersedia = 0
	var total_jumlah_dibeli = 0
	
	# 1. Hitung jenis item yang terbuka berdasarkan level
	for i in range(items.size()):
		var item_data = items[i]
		var unlock_level = item_data.get("unlock_level", 1)
		if player_level_sekarang >= unlock_level:
			total_jenis_terbuka += 1
			
	# 2. Ambil murni dari real_stock setiap baris item yang ada di layar
	for item_row in item_container.get_children():
		if item_row.has_meta("real_stock"):
			total_stok_tersedia += int(item_row.get_meta("real_stock"))
			
		if item_row.has_method("get_selected_amount"):
			total_jumlah_dibeli += item_row.get_selected_amount()
	
	# Perbarui teks label Total Stok di panel bawah
	if total_stok_label:
		total_stok_label.text = str(total_stok_tersedia)
		
	if total_jenis_label:
		total_jenis_label.text = str(total_jenis_terbuka) + " / " + str(items.size())
	
	# Perbarui status Tombol Beli
	if buy_button:
		var label_btn = buy_button.get_node_or_null("Label")
		if label_btn:
			label_btn.text = "BELI (" + str(total_jumlah_dibeli) + ")"
		
		if total_jumlah_dibeli > 0:
			buy_button.disabled = false
			buy_button.texture_normal = BTN_HIJAU
		else:
			buy_button.disabled = true
			buy_button.texture_normal = BTN_ABU

func _on_btn_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main/game.tscn")

func _on_buy_button_pressed():
	print("TOMBOL BELI DIKLIK!")
	
	var total_harga_belanjaan = 0
	
	for item_row in item_container.get_children():
		if item_row.has_method("get_selected_amount") and item_row.has_method("get_item_price"):
			var jumlah = item_row.get_selected_amount()
			var harga = item_row.get_item_price()
			total_harga_belanjaan += jumlah * harga
			
	print("Total harga belanjaan: ", total_harga_belanjaan)
	
	if total_harga_belanjaan > 0:
		var sukses = PlayerData.kurangi_coin(total_harga_belanjaan)
		if sukses:
			print("Pembelian sukses! Sisa koin:", PlayerData.coin)
			for item_row in item_container.get_children():
				if item_row.has_method("get_selected_amount") and item_row.has_method("kurangi_stok_supplier"):
					item_row.kurangi_stok_supplier()
			refresh_bottom_panel()
		else:
			print("Gagal: Koin tidak cukup!")
