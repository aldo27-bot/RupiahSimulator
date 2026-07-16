extends Node2D

@export var speed := 120.0
@export var amplitude := 18.0
@export var frequency := 2.5

var direction := 1
var base_y := 0.0
var time := 0.0

func _ready():

	base_y = position.y

	time = randf() * TAU


func _process(delta):

	time += delta

	position.x += speed * direction * delta

	position.y = base_y + sin(time * frequency) * amplitude

	if direction == 1:

		if position.x > 3500:
			queue_free()

	else:

		if position.x < -200:
			queue_free()
