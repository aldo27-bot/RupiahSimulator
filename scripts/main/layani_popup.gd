extends CanvasLayer

@onready var popup = $Popup

@onready var item_beras = $Popup/ItemContainer/Item1
@onready var item_minyak = $Popup/ItemContainer/Item2
@onready var item_telur = $Popup/ItemContainer/Item3
@onready var item_gula = $Popup/ItemContainer/Item4
@onready var item_tepung = $Popup/ItemContainer/Item5

@onready var jumlah_beras = $Popup/ItemContainer/Item1/HBoxContainer/Jumlah
@onready var jumlah_minyak = $Popup/ItemContainer/Item2/HBoxContainer/Jumlah
@onready var jumlah_telur = $Popup/ItemContainer/Item3/HBoxContainer/Jumlah
@onready var jumlah_gula = $Popup/ItemContainer/Item4/HBoxContainer/Jumlah
@onready var jumlah_tepung = $Popup/ItemContainer/Item5/HBoxContainer/Jumlah

@onready var total_label = $Popup/TotalLabel

var level_toko := 1
var current_customer = null

var pesan_beras := 0
var pesan_minyak := 0
var pesan_telur := 0
var pesan_gula := 0
var pesan_tepung := 0

var harga_item = {}


func _ready():

	layer = 20
	popup.visible = false

	var save_data = SaveManager.load_game()

	if save_data != null:
		level_toko = save_data.get("level_toko",1)

	update_level_item()
	update_ui()



# ======================
# AMBIL HARGA MARKET
# ======================

func update_harga_market():

	harga_item["beras"] = Market.get_price(
		"beras",
		ItemDatabase.get_item("beras")["base_price"]
	)

	harga_item["minyak"] = Market.get_price(
		"minyak",
		ItemDatabase.get_item("minyak")["base_price"]
	)

	harga_item["telur"] = Market.get_price(
		"telur",
		ItemDatabase.get_item("telur")["base_price"]
	)

	harga_item["gula"] = Market.get_price(
		"gula",
		ItemDatabase.get_item("gula")["base_price"]
	)

	harga_item["tepung"] = Market.get_price(
		"tepung",
		ItemDatabase.get_item("tepung")["base_price"]
	)

func get_harga(item):

	var base_price = ItemDatabase.get_item(item)["base_price"]

	return Market.get_price(
		item,
		base_price
	)



func buka_popup(customer):

	print("BUKA POPUP CUSTOMER")

	current_customer = customer

	show()

	popup.visible = true

	popup.position = Vector2(326,74)
	popup.size = Vector2(500,500)

	reset_pesanan()

	update_harga_market()

	ambil_request_customer()

	update_ui()



func tutup_popup():

	popup.visible = false



func reset_pesanan():

	pesan_beras = 0
	pesan_minyak = 0
	pesan_telur = 0
	pesan_gula = 0
	pesan_tepung = 0



func ambil_request_customer():

	if current_customer == null:
		return

	var request = current_customer.get_request()

	print(
		"CUSTOMER MINTA:",
		request["item"],
		request["amount"]
	)



func update_level_item():

	item_beras.visible = true
	item_minyak.visible = true
	item_telur.visible = true

	item_gula.visible = level_toko >= 2
	item_tepung.visible = level_toko >= 3



func tambah_beras():

	if pesan_beras < ItemDatabase.get_stock("beras"):
		pesan_beras += 1
		update_ui()


func tambah_minyak():

	if pesan_minyak < ItemDatabase.get_stock("minyak"):
		pesan_minyak += 1
		update_ui()


func tambah_telur():

	if pesan_telur < ItemDatabase.get_stock("telur"):
		pesan_telur += 1
		update_ui()


func tambah_gula():

	if pesan_gula < ItemDatabase.get_stock("gula"):
		pesan_gula += 1
		update_ui()


func tambah_tepung():

	if pesan_tepung < ItemDatabase.get_stock("tepung"):
		pesan_tepung += 1
		update_ui()



func kurang_beras():

	if pesan_beras > 0:
		pesan_beras -= 1
		update_ui()


func kurang_minyak():

	if pesan_minyak > 0:
		pesan_minyak -= 1
		update_ui()


func kurang_telur():

	if pesan_telur > 0:
		pesan_telur -= 1
		update_ui()


func kurang_gula():

	if pesan_gula > 0:
		pesan_gula -= 1
		update_ui()


func kurang_tepung():

	if pesan_tepung > 0:
		pesan_tepung -= 1
		update_ui()



func update_ui():

	jumlah_beras.text = str(pesan_beras)
	jumlah_minyak.text = str(pesan_minyak)
	jumlah_telur.text = str(pesan_telur)
	jumlah_gula.text = str(pesan_gula)
	jumlah_tepung.text = str(pesan_tepung)


	var total = 0

	total += pesan_beras * get_harga("beras")
	total += pesan_minyak * get_harga("minyak")
	total += pesan_telur * get_harga("telur")
	total += pesan_gula * get_harga("gula")
	total += pesan_tepung * get_harga("tepung")


	total_label.text = "Total : Rp " + str(total)



func layani_customer():

	var pendapatan := 0


	if pesan_beras > 0:

		ItemDatabase.remove_stock("beras", pesan_beras)

		pendapatan += pesan_beras * get_harga("beras")



	if pesan_minyak > 0:

		ItemDatabase.remove_stock("minyak", pesan_minyak)

		pendapatan += pesan_minyak * get_harga("minyak")



	if pesan_telur > 0:

		ItemDatabase.remove_stock("telur", pesan_telur)

		pendapatan += pesan_telur * get_harga("telur")



	if pesan_gula > 0:

		ItemDatabase.remove_stock("gula", pesan_gula)

		pendapatan += pesan_gula * get_harga("gula")



	if pesan_tepung > 0:

		ItemDatabase.remove_stock("tepung", pesan_tepung)

		pendapatan += pesan_tepung * get_harga("tepung")



	PlayerData.tambah_coin(pendapatan)

	print("CUSTOMER BAYAR:", pendapatan)


	if current_customer:

		current_customer.customer_done()


	SaveManager.save_current({}, level_toko)

	tutup_popup()



func _on_item_1_pressed():
	tambah_beras()

func _on_item_2_pressed():
	tambah_minyak()

func _on_item_3_pressed():
	tambah_telur()

func _on_item_4_pressed():

	if level_toko >= 2:
		tambah_gula()


func _on_item_5_pressed():

	if level_toko >= 3:
		tambah_tepung()



func _on_tombol_kurang_pressed():
	kurang_beras()

func _on_tombol_kurang_2_pressed():
	kurang_minyak()

func _on_tombol_kurang_3_pressed():
	kurang_telur()

func _on_tombol_kurang_4_pressed():
	kurang_gula()

func _on_tombol_kurang_5_pressed():
	kurang_tepung()

func _on_layani_button_pressed():

	layani_customer()
	
func _on_keluar_pressed():

	tutup_popup()
