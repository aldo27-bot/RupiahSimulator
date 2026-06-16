extends CharacterBody2D

signal reached_target

@onready var request_label = $RequestLabel
@onready var sprite = $Sprite2D

var speed = 250

var request_item = ""
var target_position : Vector2

var is_leaving = false
var target_reached = false


func _ready():

	request_label.hide()


func _physics_process(delta):

	var direction = target_position - global_position

	if direction.length() > 5:

		velocity = direction.normalized() * speed

		target_reached = false

	else:

		velocity = Vector2.ZERO

		if !target_reached:

			target_reached = true
			reached_target.emit()

	move_and_slide()


func random_request():

	var available_items = [
		"kopi",
		"beras",
		"gula"
	]

	if get_parent().level_toko >= 2:

		available_items.append("mie")
		available_items.append("susu")

	request_item = available_items.pick_random()

	request_label.text = (
		"Minta "
		+ request_item.capitalize()
	)

	request_label.show()
