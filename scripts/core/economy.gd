extends Node

var uang: int = 100000
var rupiah_strength: float = 1.0

signal uang_berubah(jumlah)

func tambah_uang(jumlah: int):
	uang += jumlah
	emit_signal("uang_berubah", uang)

func kurang_uang(jumlah: int):
	uang -= jumlah
	if uang < 0:
		uang = 0
	emit_signal("uang_berubah", uang)
