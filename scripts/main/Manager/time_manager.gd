extends Node

var hari = 1
var jam = 0
var menit = 0

func update_waktu_device():

	var waktu = Time.get_datetime_dict_from_system()

	jam = waktu.hour
	menit = waktu.minute
