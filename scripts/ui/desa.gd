extends Node2D

@onready var bgm = $BGM

var waypoints = []
var jalan_markers = []

func _ready():

	bgm.play()

	waypoints = [
		$TargetRumah1,
		$TargetRumah2,
		$TargetRumah3,
		$TargetRumah4,
		$TargetRumah5,
		$TargetWarung,
		$TargetBank
	]

	jalan_markers = [
		$MarkerJalan1,
		$MarkerJalan2,
		$MarkerJalan3,
		$MarkerJalan4,
		$MarkerJalan5,
		$MarkerJalan6,
		$MarkerJalan7,
		$MarkerJalan8,
		$MarkerJalan9,
		$MarkerJalan10,
		$MarkerJalan11,
		$MarkerJalan12,
		$MarkerJalan13,
		$MarkerJalan14,
		$MarkerJalan15
	]
