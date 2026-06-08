extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var howto_button = $VBoxContainer/HowToPlayButton
@onready var about_button = $VBoxContainer/AboutButton
@onready var setting_button = $VBoxContainer/SettingButton
@onready var exit_button = $VBoxContainer/ExitButton
@onready var reset_button = $ResetButton

func _ready():

	play_button.pressed.connect(_on_play_pressed)
	howto_button.pressed.connect(_on_howto_pressed)
	#about_button.pressed.connect(_on_about_pressed)
	#setting_button.pressed.connect(_on_setting_pressed)
	#exit_button.pressed.connect(_on_exit_pressed)
	reset_button.pressed.connect(_on_reset_pressed)

func _on_play_pressed():

	get_tree().change_scene_to_file(
		"res://scenes/main/main.tscn"
	)
	
func _on_howto_pressed():
	
	get_tree().change_scene_to_file(
		"res://scenes/menu/howtoplay.tscn"
		)
		
func _on_reset_pressed():

	SaveManager.reset_save()

	print("SAVE BERHASIL DIRESET")
	get_tree().reload_current_scene()
