extends Control

@onready var hari_label = $TopBar/Margin/TopHBox/HariPanel/HBoxContainer/HariLabel
@onready var jam_label = $TopBar/Margin/TopHBox/JamPanel/HBoxContainer/JamLabel
@onready var saldo_label = $TopBar/Margin/TopHBox/SaldoPanel/HBoxContainer/SaldoLabel

func _ready():
	# Ambil waktu dari komputer
	var waktu = Time.get_datetime_dict_from_system()

	GameData.jam = waktu.hour
	GameData.menit = waktu.minute

	update_ui()

	$GameTimer.timeout.connect(_on_game_timer_timeout)

func update_ui():
	hari_label.text = "Hari %d" % GameData.hari

	jam_label.text = "%02d:%02d" % [
		GameData.jam,
		GameData.menit
	]

	saldo_label.text = str(GameData.coin) + " Coin"


func _on_game_timer_timeout() -> void:
	var waktu = Time.get_datetime_dict_from_system()

	GameData.jam = waktu.hour
	GameData.menit = waktu.minute

	update_ui()
