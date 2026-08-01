extends Control

# ==========================
# RINGKASAN
# ==========================

@onready var label_jenis = $Panel/Ringkasan/LabelJenis
@onready var label_stok = $Panel/Ringkasan/LabelStok


# ==========================
# JUMLAH SETIAP BARANG
# ==========================

@onready var jumlah_beras = $Panel/Barang/Daftar/Beras/Jumlah
@onready var jumlah_minyak = $Panel/Barang/Daftar/Minyak/Jumlah
@onready var jumlah_telur = $Panel/Barang/Daftar/Telur/Jumlah
@onready var jumlah_gula = $Panel/Barang/Daftar/Gula/Jumlah
@onready var jumlah_tepung = $Panel/Barang/Daftar/Tepung/Jumlah


# ==========================
# ITEM
# ==========================

@onready var beras = $Panel/Barang/Daftar/Beras
@onready var minyak = $Panel/Barang/Daftar/Minyak
@onready var telur = $Panel/Barang/Daftar/Telur
@onready var gula = $Panel/Barang/Daftar/Gula
@onready var tepung = $Panel/Barang/Daftar/Tepung


# ==========================
# DATA DUMMY
# ==========================

var level_toko := 1

var stok = {
	"beras": 10,
	"minyak": 6,
	"telur": 8,
	"gula": 0,
	"tepung": 0
}


# ==========================
# READY
# ==========================

func _ready():

	update_ui()


# ==========================
# UPDATE UI
# ==========================

func update_ui():

	jumlah_beras.text = str(stok["beras"])
	jumlah_minyak.text = str(stok["minyak"])
	jumlah_telur.text = str(stok["telur"])
	jumlah_gula.text = str(stok["gula"])
	jumlah_tepung.text = str(stok["tepung"])

	update_ringkasan()
	update_level()


# ==========================
# RINGKASAN
# ==========================

func update_ringkasan():

	var total_jenis := 0
	var total_stok := 0

	for item in stok:

		total_stok += stok[item]

		if stok[item] > 0:
			total_jenis += 1

	label_jenis.text = "Jenis Barang : %d" % total_jenis
	label_stok.text = "Total Stok : %d" % total_stok


# ==========================
# LEVEL BARANG
# ==========================

func update_level():

	# Level 1
	beras.visible = true
	minyak.visible = true
	telur.visible = true

	# Level 2
	gula.visible = level_toko >= 2

	# Level 3
	tepung.visible = level_toko >= 3


# ==========================
# GANTI LEVEL (DUMMY)
# ==========================

func set_level(level:int):

	level_toko = level
	update_ui()


# ==========================
# GANTI STOK (DUMMY)
# ==========================

func set_stok(nama_barang:String, jumlah:int):

	if stok.has(nama_barang):
		stok[nama_barang] = jumlah

	update_ui()


func _on_kembali_pressed() -> void:
	hide()
