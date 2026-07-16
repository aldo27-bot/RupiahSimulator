extends CanvasLayer

signal accepted
signal cancelled

@onready var dark = $DarkBackground
@onready var panel = $PopupPanel
@onready var button_yes = $PopupPanel/ButtonYes
@onready var button_no = $PopupPanel/ButtonNo

func _ready():

	button_yes.pressed.connect(_on_button_yes_pressed)
	button_no.pressed.connect(_on_button_no_pressed)

	hide_popup()

func show_popup():

	visible = true
	dark.visible = true
	panel.visible = true

	get_tree().paused = true

func hide_popup():

	get_tree().paused = false

	dark.visible = false
	panel.visible = false

	visible = false

func _on_button_yes_pressed():

	hide_popup()
	accepted.emit()

func _on_button_no_pressed():

	hide_popup()
	cancelled.emit()
