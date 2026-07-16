extends CanvasLayer

signal buy_pressed
signal claim_pressed
signal close_pressed

@onready var dark = $DarkBackground
@onready var popup = $Popup

@onready var buy_button = $Popup/BuyButton
@onready var claim_button = $Popup/ClaimButton
@onready var close_button = $Popup/CloseButton


const POPUP_BUY = preload("res://assets/images/popup/popup_beliwarung.png")
const POPUP_CLAIM = preload("res://assets/images/popup/popup_klaimwarung.png")


func _ready():

	hide()

	claim_button.hide()


# ===========================
# POPUP BELI
# ===========================

func show_buy_popup():

	popup.texture = POPUP_BUY

	buy_button.show()
	claim_button.hide()

	show()


# ===========================
# POPUP KLAIM
# ===========================

func show_claim_popup():

	popup.texture = POPUP_CLAIM

	buy_button.hide()
	claim_button.show()

	show()


# ===========================
# TUTUP POPUP
# ===========================

func hide_popup():

	hide()


# ===========================
# SIGNAL BUTTON
# ===========================

func _on_buy_button_pressed():

	buy_pressed.emit()


func _on_claim_button_pressed():

	claim_pressed.emit()


func _on_close_button_pressed():

	close_pressed.emit()

	hide_popup()
