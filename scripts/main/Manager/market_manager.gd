extends Node

class_name MarketManager

enum Trend {
	NAIK,
	TURUN
}

var persen := 0
var trend := Trend.NAIK

const MAX_PERCENT = 20
const MIN_PERCENT = 1

func _ready():
	randomize()

func update_market():

	# 50% naik, 50% turun
	trend = Trend.NAIK if randf() < 0.5 else Trend.TURUN

	# Persentase acak
	persen = randi_range(MIN_PERCENT, MAX_PERCENT)

	print("Market :", trend, " Persen :", persen)
