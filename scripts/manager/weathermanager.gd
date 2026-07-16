extends Node

signal weather_changed(weather)

enum Weather {
	CLEAR,
	RAIN
}

var current_weather : Weather = Weather.CLEAR


func set_weather(weather : Weather):

	if current_weather == weather:
		return

	current_weather = weather

	weather_changed.emit(current_weather)
