extends Node

# Signal untuk memberitahu UI setiap kali koin bertambah/berkurang
signal saldo_berubah(saldo_baru)

# Modal awal kamu
var coin: int = 100000

# Fungsi untuk menambah koin (jika jualan laku)
func tambah_coin(jumlah: int):
	coin += jumlah
	saldo_berubah.emit(coin)

# Fungsi untuk mengurangi koin (saat beli di supplier)
func kurangi_coin(jumlah: int) -> bool:
	if coin >= jumlah:
		coin -= jumlah
		saldo_berubah.emit(coin)
		return true # Sukses beli
	else:
		return false # Gagal beli karena uang kurang
