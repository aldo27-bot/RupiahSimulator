extends Node2D

@export var bird_scene : PackedScene

@export var left_spawn = -200
@export var right_spawn = 3400

@export var top_spawn = 80
@export var bottom_spawn = 350

func _ready():

	randomize()

	spawn_loop()


func spawn_loop():

	while true:

		var jumlah = randi_range(1,3)

		for i in jumlah:

			spawn_bird(i)

		await get_tree().create_timer(randf_range(15,30)).timeout


func spawn_bird(index):

	var bird = bird_scene.instantiate()

	add_child(bird)

	var dari_kiri = randf() < 0.5

	var tinggi = randf_range(top_spawn,bottom_spawn)

	if dari_kiri:

		bird.position = Vector2(left_spawn,tinggi)

		bird.direction = 1

		bird.scale.x = 1

	else:

		bird.position = Vector2(right_spawn,tinggi)

		bird.direction = -1

		bird.scale.x = -1

	bird.position.y += index * randf_range(-25,25)

	bird.speed += randf_range(-15,15)

	bird.amplitude += randf_range(-5,5)

	bird.frequency += randf_range(-0.4,0.4)
