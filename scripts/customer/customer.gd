extends CharacterBody2D

@onready var request_label = $RequestLabel

var speed = 250
var target_x = 450

var request_item = ""

func _ready():

	random_request()

func _physics_process(delta):

	if position.x < target_x:
		position.x += speed * delta

func random_request():

	var items = [
		"kopi",
		"beras",
		"gula"
	]

	# LEVEL 2
	if Market.items.has("mie"):
		items.append("mie")

	if Market.items.has("susu"):
		items.append("susu")

	request_item = items.pick_random()

	request_label.text = (
		"Minta "
		+ request_item.capitalize()
	)
