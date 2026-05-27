extends Node

@onready var timer = $Timer

func _ready():
	timer.start()


func _on_timer_timeout():
	# fluktuasi rupiah
	var change = randf_range(-0.05, 0.05)

	Economy.rupiah_strength += change
	Economy.rupiah_strength = clamp(Economy.rupiah_strength, 0.5, 1.5)

	print("Rupiah:", Economy.rupiah_strength)
