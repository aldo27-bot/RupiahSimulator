extends Node

var items = {
	"kopi": {"stok": 0, "base_price": 1000},
	"beras": {"stok": 0, "base_price": 15000},
	"gula": {"stok": 0, "base_price": 12000}
}

signal stok_berubah(item, stok)

# ======================
# UNLOCK ITEM LEVEL 2
# ======================
func unlock_level_2_items():

	if not items.has("mie"):
		items["mie"] = {
			"stok": 0,
			"base_price": 3500
		}

	if not items.has("susu"):
		items["susu"] = {
			"stok": 0,
			"base_price": 8000
		}

# ======================
# HARGA JUAL DINAMIS
# ======================
func get_sell_price(item: String) -> int:

	var base = items[item]["base_price"]
	var stok = items[item]["stok"]

	# SIMPLE ECONOMY RULE
	var modifier = 1.0

	if stok > 20:
		modifier = 0.8

	elif stok < 5:
		modifier = 1.3

	return int(base * modifier)

# ======================
# HARGA BELI
# ======================
func get_price(item: String) -> int:

	return items[item]["base_price"]

# ======================
# BELI
# ======================
func beli_dari_supplier(
	item: String,
	jumlah: int,
	harga: int
):

	var total = harga * jumlah

	if Economy.uang >= total:

		Economy.kurang_uang(total)

		items[item]["stok"] += jumlah

		emit_signal(
			"stok_berubah",
			item,
			items[item]["stok"]
		)

# ======================
# JUAL
# ======================
func jual(item: String):

	if items[item]["stok"] > 0:

		items[item]["stok"] -= 1

		var price = get_sell_price(item)

		Economy.tambah_uang(price)

		emit_signal(
			"stok_berubah",
			item,
			items[item]["stok"]
		)

		return price

	return 0
