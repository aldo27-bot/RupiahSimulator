extends Node

var supplier_price = {
	"kopi": 800,
	"beras": 12000,
	"gula": 10000,

	# LEVEL 2
	"mie": 2500,
	"susu": 6000
}

func get_price(item):

	if supplier_price.has(item):
		return supplier_price[item]

	return 0
