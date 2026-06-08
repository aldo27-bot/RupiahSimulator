extends Node

const SAVE_PATH = "user://savegame.json"


# ======================
# SAVE GAME
# ======================
func save_game(cart_data, level_toko):

	var save_data = {
		"uang": Economy.uang,
		"rupiah": Economy.rupiah_strength,
		"items": Market.items,
		"cart": cart_data,
		"level_toko": level_toko
	}

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	file.store_string(
		JSON.stringify(save_data)
	)

	print("GAME SAVED")


# ======================
# LOAD GAME
# ======================
func load_game():

	if not FileAccess.file_exists(SAVE_PATH):
		print("NO SAVE FILE")
		return null

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	var content = file.get_as_text()

	var data = JSON.parse_string(content)

	if data == null:
		print("SAVE CORRUPT")
		return null

	print("GAME LOADED")

	return data
	
# ======================
# RESET SAVE
# ======================
func reset_save():

	var save_data = {
		"uang": 100000,
		"rupiah": 1.0,
		"level_toko": 1,

		"cart": {
			"kopi": 0,
			"beras": 0,
			"gula": 0
		},

		"items": {
			"kopi": {
				"stok": 0,
				"base_price": 1000
			},

			"beras": {
				"stok": 0,
				"base_price": 15000
			},

			"gula": {
				"stok": 0,
				"base_price": 12000
			}
		}
	}

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	file.store_string(
		JSON.stringify(save_data)
	)

	print("GAME RESET")
