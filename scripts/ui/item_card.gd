extends Control

func set_item(nama, harga, icon, stok = -1):

	$VBoxContainer/Nama.text = nama
	$VBoxContainer/Harga.text = "Rp " + str(harga)
	$VBoxContainer/Icon.texture = icon

	if stok >= 0:
		$VBoxContainer/Stok.visible = true
		$VBoxContainer/Stok.text = "Stok : " + str(int(stok))
	else:
		$VBoxContainer/Stok.visible = false
