extends Node2D

@onready var bgm = $BGM

var waypoints = []
var jalan_markers = []

func _ready():

	bgm.play()
