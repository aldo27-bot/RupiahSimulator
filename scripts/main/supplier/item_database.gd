extends Node

signal stock_changed

var items = {

	"beras": {

		"id": "beras",
		"name": "Beras",

		"icon": preload(
			"res://assets/warung/supplier/beras.png"
		),

		"base_price": 12000,

		# STOK MILIK PEMAIN
		"stock": 0,

		"unlock_level": 1,

		"max_stock": 999
	},

	"minyak": {

		"id": "minyak",
		"name": "Minyak Goreng",

		"icon": preload(
			"res://assets/warung/supplier/minyak.png"
		),

		"base_price": 15000,

		"stock": 0,

		"unlock_level": 1,

		"max_stock": 999
	},

	"telur": {

		"id": "telur",
		"name": "Telur",

		"icon": preload(
			"res://assets/warung/supplier/telur.png"
		),

		"base_price": 25000,

		"stock": 0,

		"unlock_level": 1,

		"max_stock": 999
	},

	"gula": {

		"id": "gula",
		"name": "Gula",

		"icon": preload(
			"res://assets/warung/supplier/gula.png"
		),

		"base_price": 18000,

		"stock": 0,

		"unlock_level": 2,

		"max_stock": 999
	},

	"tepung": {

		"id": "tepung",
		"name": "Tepung",

		"icon": preload(
			"res://assets/warung/supplier/tepung.png"
		),

		"base_price": 17000,

		"stock": 0,

		"unlock_level": 3,

		"max_stock": 999
	}
}

# ==========================
# GET ITEM
# ==========================

func get_item(id:String) -> Dictionary:

	if items.has(id):

		return items[id]

	return {}

# ==========================
# GET STOCK PEMAIN
# ==========================

func get_stock(id:String) -> int:

	if items.has(id):

		return items[id]["stock"]

	return 0

# ==========================
# SET STOCK
# ==========================

func set_stock(
	id:String,
	jumlah:int
):

	if !items.has(id):

		return

	items[id]["stock"] = clamp(
		jumlah,
		0,
		items[id]["max_stock"]
	)

	stock_changed.emit()

# ==========================
# TAMBAH STOCK
# DIPAKAI SAAT BELI SUPPLIER
# ==========================

func add_stock(
	id:String,
	jumlah:int
):

	if !items.has(id):

		return

	items[id]["stock"] += jumlah

	if items[id]["stock"] > items[id]["max_stock"]:

		items[id]["stock"] = items[id]["max_stock"]

	stock_changed.emit()

# ==========================
# KURANGI STOCK
# DIPAKAI SAAT JUAL BARANG
# ==========================

func remove_stock(
	id:String,
	jumlah:int
) -> bool:

	if !items.has(id):

		return false

	if items[id]["stock"] < jumlah:

		return false

	items[id]["stock"] -= jumlah

	stock_changed.emit()
	return true

# ==========================
# TOTAL STOCK PEMAIN
# ==========================

func get_player_total_stock() -> int:

	var total := 0

	for id in items:

		total += items[id]["stock"]
	return total
	
# ==========================
# TOTAL JENIS BARANG
# ==========================

func get_total_item_types() -> int:

	var total := 0

	for id in items:

		if items[id]["stock"] > 0:

			total += 1
	return total

# ==========================
# ITEM TERBUKA SESUAI LEVEL
# ==========================

func get_unlocked_items(
	level:int
) -> Array:
	
	var daftar := []

	for id in items:

		if level >= items[id]["unlock_level"]:

			daftar.append(
				items[id]
			)
	return daftar

# ==========================
# RESET GAME BARU
# ==========================

func reset_stock():

	for id in items:

		items[id]["stock"] = 0

	stock_changed.emit()
