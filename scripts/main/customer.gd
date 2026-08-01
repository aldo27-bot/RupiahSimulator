extends CharacterBody2D

signal reached_target
signal finished

@onready var request_label = $RequestLabel
@onready var sprite = $AnimatedSprite2D

@export var speed = 140.0

var target_position : Vector2
var spawn_position : Vector2

var request_item = ""
var request_amount = 1

var target_reached = false
var pulang = false


func _ready():

	request_label.hide()

	sprite.position = Vector2.ZERO

	spawn_position = global_position



func set_target(pos: Vector2):

	target_position = pos

	target_reached = false

	pulang = false

	print("CUSTOMER MENUJU:", target_position)



func _physics_process(delta):

	if target_position == Vector2.ZERO:
		return


	var direction = target_position - global_position


	if direction.length() > 5:

		velocity = direction.normalized() * speed

		update_animation(direction)

		target_reached = false


	else:

		velocity = Vector2.ZERO

		sprite.stop()


		if !target_reached:

			target_reached = true


			if pulang:

				print("CUSTOMER KELUAR")
				finished.emit()

			else:

				print("CUSTOMER SAMPAI KASIR")

				reached_target.emit()


	move_and_slide()



func update_animation(direction):

	if abs(direction.x) > abs(direction.y):

		sprite.play("walk_side")

		sprite.flip_h = direction.x > 0


	elif direction.y > 0:

		sprite.play("walk_down")


	else:

		sprite.play("walk_up")



# ======================
# REQUEST CUSTOMER
# ======================

func random_request():

	var available_items = [
		"beras",
		"minyak",
		"telur"
	]


	request_item = available_items.pick_random()

	request_amount = randi_range(1,2)


	request_label.text = (
		"Minta "
		+ request_item.capitalize()
		+ "\nJumlah: "
		+ str(request_amount)
	)


	request_label.show()


	print(
		"CUSTOMER REQUEST:",
		request_item,
		"x",
		request_amount
	)



# ======================
# AMBIL REQUEST
# ======================

func get_request():

	return {
		"item": request_item,
		"amount": request_amount
	}

# ======================
# SELESAI DILAYANI
# ======================

func customer_done():

	request_label.hide()

	pulang = true

	target_reached = false

	target_position = spawn_position

	print("CUSTOMER KEMBALI")

func reset_customer():

	request_item = ""

	request_amount = 1

	target_position = Vector2.ZERO

	target_reached = false

	pulang = false

	request_label.hide()

	velocity = Vector2.ZERO

func customer_rejected():

	request_label.hide()

	pulang = true

	target_reached = false

	target_position = spawn_position

	print("CUSTOMER DITOLAK")
