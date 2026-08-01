extends Node

signal market_updated

enum Trend {
	NAIK,
	TURUN
}

var persen := 0
var trend := Trend.NAIK

const MAX_PERCENT := 20
const MIN_PERCENT := 1

func _ready():
	randomize()
	update_market()

func update_market():
	trend = Trend.NAIK if randf() < 0.5 else Trend.TURUN
	persen = randi_range(MIN_PERCENT, MAX_PERCENT)

	print("Market berubah! Trend:", trend, " Persen:", persen)

	market_updated.emit()

func get_price(base_price:int) -> int:
	if trend == Trend.NAIK:
		return round(base_price * (1.0 + persen / 100.0))
	else:
		return round(base_price * (1.0 - persen / 100.0))
