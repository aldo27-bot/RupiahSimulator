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
		"level_toko": level_toko,

		"businesses": {
			"warung": {
				"owned": BusinessData.businesses["warung"]["owned"],
				"stored_profit": BusinessData.businesses["warung"]["stored_profit"],
				"last_collect_time": BusinessData.businesses["warung"]["last_collect_time"]
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
		},
		
		"businesses": {
			"warung": {
				"owned": false,
				"stored_profit": 0,
				"last_collect_time": 0
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
	
# ======================
# APPLY SAVE DATA
# ======================
func apply_loaded_data():

	var data = load_game()

	if data == null:
		return null

	# Economy
	Economy.uang = data["uang"]
	Economy.rupiah_strength = data["rupiah"]

	# Market
	Market.items = data["items"]

	# Business
	if data.has("businesses"):

		var warung = data["businesses"]["warung"]

		BusinessData.businesses["warung"]["owned"] = warung["owned"]
		BusinessData.businesses["warung"]["stored_profit"] = warung["stored_profit"]
		BusinessData.businesses["warung"]["last_collect_time"] = warung["last_collect_time"]

	return data

# ======================
# SAVE CURRENT GAME
# ======================
func save_current(cart_data, level_toko):

	save_game(cart_data, level_toko)

# ======================
# SAVE BUSINESS ONLY
# ======================
func save_business():

	var data = load_game()

	if data == null:

		data = {
			"uang": Economy.uang,
			"rupiah": Economy.rupiah_strength,
			"items": Market.items,
			"cart": {},
			"level_toko": 1
		}

	data["uang"] = Economy.uang

	data["businesses"] = {

		"warung": {

			"owned": BusinessData.businesses["warung"]["owned"],

			"stored_profit":
			BusinessData.businesses["warung"]["stored_profit"],

			"last_collect_time":
			BusinessData.businesses["warung"]["last_collect_time"]

		}

	}

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	file.store_string(
		JSON.stringify(data)
	)

	print("BUSINESS SAVED")
