extends Control

@onready var item_container = $ItemContainer

var item_scene = preload("res://scenes/main/supplier/item.tscn")

var items = [
	{
		"name":"Beras",
		"icon":preload("res://assets/warung/supplier/beras.png"),
		"price":120,
		"stock":10
	},
	{
		"name":"Minyak Goreng",
		"icon":preload("res://assets/warung/supplier/minyak.png"),
		"price":132,
		"stock":6
	},
	{
		"name":"Telur",
		"icon":preload("res://assets/warung/supplier/telur.png"),
		"price":144,
		"stock":8
	}
]

func _ready():

	for i in range(items.size()):

		var row = item_scene.instantiate()

		item_container.add_child(row)

		row.position = Vector2(0, i * 62)

		row.setup(items[i])
