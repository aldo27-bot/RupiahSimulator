extends Node

var supplier_price = {
	"kopi": 800,
	"beras": 12000,
	"gula": 10000
}

func get_price(item):
	return supplier_price[item]
