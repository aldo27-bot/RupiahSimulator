extends Node

const SAVE_PATH = "user://savegame.json"


# ======================
# SAVE GAME
# ======================
func save_game(cart_data):

	var save_data = {
		"uang": Economy.uang,
		"rupiah": Economy.rupiah_strength,
		"items": Market.items,
		"cart": cart_data
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
