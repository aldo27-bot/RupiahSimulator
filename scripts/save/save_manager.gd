extends Node

const SAVE_PATH = "user://savegame.json"

# ======================
# SAVE GAME
# ======================
func save_game(cart_data, level_toko):

	var save_data = {
		"uang": PlayerData.coin,
		"rupiah": Economy.rupiah_strength,

		"items": Market.item_markets,

		"stocks": {
			"beras": ItemDatabase.get_stock("beras"),
			"minyak": ItemDatabase.get_stock("minyak"),
			"telur": ItemDatabase.get_stock("telur"),
			"gula": ItemDatabase.get_stock("gula"),
			"tepung": ItemDatabase.get_stock("tepung")
		},

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

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))

	print("GAME SAVED")


# ======================
# LOAD GAME
# ======================
func load_game():

	if !FileAccess.file_exists(SAVE_PATH):
		print("NO SAVE FILE")
		return null

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
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

		"items": {},

		"stocks": {
			"beras": 0,
			"minyak": 0,
			"telur": 0,
			"gula": 0,
			"tepung": 0
		},

		"businesses": {
			"warung": {
				"owned": false,
				"stored_profit": 0,
				"last_collect_time": 0
			}
		}
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))

	print("GAME RESET")


# ======================
# APPLY SAVE DATA
# ======================
func apply_loaded_data():

	var data = load_game()

	if data == null:
		return null

	# Money
	PlayerData.coin = data["uang"]
	PlayerData.saldo_berubah.emit(PlayerData.coin)

	# Economy
	Economy.rupiah_strength = data["rupiah"]

	# Market
	if data.has("items"):
		Market.item_markets = data["items"]

	# Stock
	if data.has("stocks"):

		var s = data["stocks"]

		ItemDatabase.set_stock("beras", s.get("beras", 0))
		ItemDatabase.set_stock("minyak", s.get("minyak", 0))
		ItemDatabase.set_stock("telur", s.get("telur", 0))
		ItemDatabase.set_stock("gula", s.get("gula", 0))
		ItemDatabase.set_stock("tepung", s.get("tepung", 0))

		ItemDatabase.stock_changed.emit()

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
			"uang": PlayerData.coin,
			"rupiah": Economy.rupiah_strength,
			"items": Market.item_markets,
			"stocks": {},
			"cart": {},
			"level_toko": 1
		}

	data["uang"] = PlayerData.coin

	data["businesses"] = {

		"warung": {

			"owned": BusinessData.businesses["warung"]["owned"],
			"stored_profit": BusinessData.businesses["warung"]["stored_profit"],
			"last_collect_time": BusinessData.businesses["warung"]["last_collect_time"]

		}

	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

	print("BUSINESS SAVED")


# ======================
# SAVE ITEM DATABASE
# ======================
func save_item_database():

	var data = load_game()

	if data == null:
		data = {}

	data["stocks"] = {

		"beras": ItemDatabase.get_stock("beras"),
		"minyak": ItemDatabase.get_stock("minyak"),
		"telur": ItemDatabase.get_stock("telur"),
		"gula": ItemDatabase.get_stock("gula"),
		"tepung": ItemDatabase.get_stock("tepung")

	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

	print("ITEM DATABASE SAVED")
