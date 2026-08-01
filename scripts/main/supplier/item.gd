extends Control 

const ICON_NAIK = preload("res://assets/warung/ui/Naik.png")
const ICON_TURUN = preload("res://assets/warung/ui/Turun.png")

var base_price : int = 0
var item_level_required : int = 1
var player_level : int = 1 

# Variabel untuk menghitung jumlah item yang dipilih/dibeli
var current_amount : int = 0

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

# Variabel penampung untuk latar belakang abu-abu via kode
var bg_overlay : ColorRect

func _ready():
	Market.market_updated.connect(refresh_item_ui)
	
	# Membuat ColorRect secara otomatis via kode saat game pertama kali dimuat
	bg_overlay = ColorRect.new()
	bg_overlay.name = "AutoBgOverlay"
	bg_overlay.color = Color(0.5, 0.5, 0.5, 0.3) # Warna abu-abu samar
	bg_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT) # Menyesuaikan ukuran baris penuh
	bg_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE # Agar tidak menghalangi klik mouse
	bg_overlay.visible = false
	
	# Masukkan ke dalam urutan paling bawah (indeks 0) agar berada di belakang teks/icon
	add_child(bg_overlay)
	move_child(bg_overlay, 0)
	
	# Hubungkan tombol plus dan minus secara otomatis via kode (atau pastikan sudah terhubung di Node Inspector)
	if not minus_button.pressed.is_connected(_on_minus_pressed):
		minus_button.pressed.connect(_on_minus_pressed)
	if not plus_button.pressed.is_connected(_on_plus_pressed):
		plus_button.pressed.connect(_on_plus_pressed)
		
	# Set tampilan awal angka
	amount_label.text = str(current_amount)

func setup(data, current_player_level: int = 1):
	base_price = data.price 
	item_level_required = data.get("unlock_level", 1) 
	player_level = current_player_level
	
	nama_label.text = data.name
	if data.get("icon") != null:
		icon_rect.texture = data.icon
		
	set_meta("real_stock", data.get("stock", 0))
	refresh_item_ui()

func refresh_item_ui():
	if player_level < item_level_required:
		setup_locked_ui()
		return 
	
	setup_unlocked_ui()
	
	# Ambil harga dan tren unik khusus barang ini dari Market (Menggunakan fungsi baru)
	var current_price = Market.get_price(base_price)
	var trend_data = Market.get_item_trend_data(base_price)
	
	price_label.text = str(current_price)
	
	# Menggunakan trend_data dari kamus item, BUKAN Market.trend global lagi
	if trend_data.trend == Market.Trend.NAIK:
		trend_label.text = "+" + str(trend_data.persen) + "%"
		trend_label.add_theme_color_override("font_color", Color(0, 0.8, 0)) 
		trend_icon.texture = ICON_NAIK
	else:
		trend_label.text = "-" + str(trend_data.persen) + "%"
		trend_label.add_theme_color_override("font_color", Color(0.8, 0, 0)) 
		trend_icon.texture = ICON_TURUN

func setup_locked_ui():
	price_label.visible = false
	coin_icon.visible = false
	trend_icon.visible = false
	stock_label.visible = false
	
	minus_button.visible = false
	amount_label.visible = false
	plus_button.visible = false
	locked_buy_button.visible = true
		
	if lock_icon:
		lock_icon.visible = true
	
	trend_label.visible = true 
	trend_label.text = "Akan terbuka di Level " + str(item_level_required)
	trend_label.add_theme_color_override("font_color", Color(0.4, 0.3, 0.2)) 
	
	minus_button.disabled = true
	plus_button.disabled = true
	
	# Aktifkan background abu-abu via kode
	if bg_overlay:
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
		
	if lock_icon:
		lock_icon.visible = false
	
	if has_meta("real_stock"):
		stock_label.text = str(get_meta("real_stock"))
		
	minus_button.disabled = false
	plus_button.disabled = false
	
	# Sembunyikan background abu-abu kembali normal
	if bg_overlay:
		bg_overlay.visible = false

# --- FUNGSI UNTUK MENGELOLA JUMLAH BELANJAAN ---

func get_selected_amount() -> int:
	return current_amount

func _on_plus_pressed():
	var max_stock = get_meta("real_stock") if has_meta("real_stock") else 99
	# Batasi agar tidak melebihi stok yang tersedia
	if current_amount < max_stock:
		current_amount += 1
		amount_label.text = str(current_amount)
		notif_supplier_update()

func _on_minus_pressed():
	if current_amount > 0:
		current_amount -= 1
		amount_label.text = str(current_amount)
		notif_supplier_update()

func notif_supplier_update():
	var supplier_node = get_tree().get_first_node_in_group("supplier_group")
	if supplier_node and supplier_node.has_method("refresh_bottom_panel"):
		supplier_node.refresh_bottom_panel()
		
# --- FUNGSI TAMBAHAN UNTUK TRANSAKSI SUPPLIER ---

# Mengambil harga barang saat ini (sinkron dengan market unik)
func get_item_price() -> int:
	return Market.get_price(base_price)

# Mengurangi stok setelah tombol beli ditekan dan koin berhasil dipotong
func kurangi_stok_supplier():
	if has_meta("real_stock"):
		var stok_sekarang = int(get_meta("real_stock"))
		var sisa_stok = stok_sekarang - current_amount
		
		if sisa_stok < 0:
			sisa_stok = 0
			
		set_meta("real_stock", sisa_stok)
		stock_label.text = str(sisa_stok)
		
	current_amount = 0
	amount_label.text = str(current_amount)
	
	notif_supplier_update()
