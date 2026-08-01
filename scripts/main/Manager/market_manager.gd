extends Node

signal market_updated

enum Trend {
	NAIK,
	TURUN
}

const MAX_PERCENT := 20
const MIN_PERCENT := 1

# Dictionary untuk menyimpan data market unik tiap barang (berdasarkan base_price atau nama)
var item_markets = {}

func _ready():
	randomize()
	update_market()
	
	# Membuat Timer secara dinamis lewat script
	var timer = Timer.new()
	timer.wait_time = 10.0 # Market berubah setiap 10 detik
	timer.autostart = true
	timer.timeout.connect(update_market)
	add_child(timer)

func update_market():
	# Kosongkan atau acak ulang data setiap kali timer market berdetak
	item_markets.clear()
	print("Market global berubah! Setiap barang mengacak trennya sendiri.")
	market_updated.emit()

# Fungsi untuk mendapatkan harga unik per item berdasarkan base_price-nya
func get_price(item_name:String, base_price:int) -> int:

	if not item_markets.has(item_name):

		var item_trend = Trend.NAIK if randf() < 0.5 else Trend.TURUN
		var item_persen = randi_range(MIN_PERCENT, MAX_PERCENT)

		item_markets[item_name] = {
			"trend": item_trend,
			"persen": item_persen
		}


	var data = item_markets[item_name]


	print(
		item_name,
		" | ",
		"NAIK" if data.trend == Trend.NAIK else "TURUN",
		" ",
		data.persen,
		"%"
	)


	if data.trend == Trend.NAIK:

		return round(
			base_price * (1.0 + data.persen / 100.0)
		)

	else:

		return round(
			base_price * (1.0 - data.persen / 100.0)
		)

# Fungsi tambahan untuk mengambil info tren & persen khusus item (untuk ikon naik/turun di item.gd)
func get_item_trend_data(item_name:String, base_price:int) -> Dictionary:

	if not item_markets.has(item_name):
		get_price(item_name, base_price)

	return item_markets[item_name]
