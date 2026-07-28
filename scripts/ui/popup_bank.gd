extends Control

signal popup_closed

func _ready():

	visible = false

func show_popup():

	visible = true

func hide_popup():

	visible = false

	popup_closed.emit()


func _on_btn_tutup_pressed():

	hide_popup()
