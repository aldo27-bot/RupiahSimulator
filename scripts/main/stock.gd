extends Control


# ==========================
# RINGKASAN
# ==========================

@onready var label_jenis = $Panel/Ringkasan/LabelJenis
@onready var label_stok = $Panel/Ringkasan/LabelStok



# ==========================
# JUMLAH BARANG
# ==========================

@onready var jumlah_beras = $Panel/Barang/Daftar/Beras/Jumlah
@onready var jumlah_minyak = $Panel/Barang/Daftar/Minyak/Jumlah
@onready var jumlah_telur = $Panel/Barang/Daftar/Telur/Jumlah
@onready var jumlah_gula = $Panel/Barang/Daftar/Gula/Jumlah
@onready var jumlah_tepung = $Panel/Barang/Daftar/Tepung/Jumlah



# ==========================
# ITEM CONTAINER
# ==========================

@onready var beras = $Panel/Barang/Daftar/Beras
@onready var minyak = $Panel/Barang/Daftar/Minyak
@onready var telur = $Panel/Barang/Daftar/Telur
@onready var gula = $Panel/Barang/Daftar/Gula
@onready var tepung = $Panel/Barang/Daftar/Tepung



# ==========================
# LEVEL TOKO
# ==========================

var level_toko := 1





# ==========================
# READY
# ==========================

func _ready():


	# Ambil level dari save

	var save_data = SaveManager.load_game()


	if save_data != null:

		level_toko = save_data.get(
			"level_toko",
			1
		)


	# Update ketika stok berubah

	if !ItemDatabase.stock_changed.is_connected(
		update_ui
	):

		ItemDatabase.stock_changed.connect(
			update_ui
		)



	update_ui()





# ==========================
# UPDATE UI
# ==========================

func update_ui():


	jumlah_beras.text = str(
		ItemDatabase.get_stock("beras")
	)


	jumlah_minyak.text = str(
		ItemDatabase.get_stock("minyak")
	)


	jumlah_telur.text = str(
		ItemDatabase.get_stock("telur")
	)


	jumlah_gula.text = str(
		ItemDatabase.get_stock("gula")
	)


	jumlah_tepung.text = str(
		ItemDatabase.get_stock("tepung")
	)



	update_ringkasan()

	update_level()





# ==========================
# RINGKASAN
# ==========================

func update_ringkasan():


	label_jenis.text = (
		"Jenis Barang : %d"
		% ItemDatabase.get_total_item_types()
	)



	label_stok.text = (
		"Total Stok : %d"
		% ItemDatabase.get_player_total_stock()
	)





# ==========================
# LEVEL BARANG
# ==========================

func update_level():


	beras.visible = true
	minyak.visible = true
	telur.visible = true



	gula.visible = level_toko >= 2

	tepung.visible = level_toko >= 3





# ==========================
# SET LEVEL
# ==========================

func set_level(
	level:int
):

	level_toko = level

	update_level()





# ==========================
# TOMBOL KEMBALI
# ==========================

func _on_kembali_pressed() -> void:

	hide()
