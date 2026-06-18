extends Node2D

@onready var npc_a: AnimatedSprite2D = $NPC_A
@onready var npc_b: AnimatedSprite2D = $NPC_B

@onready var bubble_a: NinePatchRect = $Bubble_A
@onready var bubble_b: NinePatchRect = $Bubble_B

@onready var label_a: Label = $Bubble_A/Label_A
@onready var label_b: Label = $Bubble_B/Label_B


var dialogs = [
	{
		"speaker": "A",
		"text": "Pak, harga barang naik lagi."
	},
	{
		"speaker": "B",
		"text": "Iya, rupiah sedang melemah."
	},
	{
		"speaker": "A",
		"text": "Dampaknya terasa sekali."
	},
	{
		"speaker": "B",
		"text": "Betul, semua jadi mahal."
	},
	{
		"speaker": "A",
		"text": "Beras juga naik."
	},
	{
		"speaker": "B",
		"text": "Minyak dan gula juga."
	},
	{
		"speaker": "A",
		"text": "Pembeli jadi sepi."
	},
	{
		"speaker": "B",
		"text": "Daya beli turun."
	},
	{
		"speaker": "A",
		"text": "Warung jadi kurang ramai."
	},
	{
		"speaker": "B",
		"text": "Pendapatan ikut turun."
	},
	{
		"speaker": "A",
		"text": "Kenapa bisa begini ya?"
	},
	{
		"speaker": "B",
		"text": "Nilai tukar tidak stabil."
	},
	{
		"speaker": "A",
		"text": "Barang impor jadi mahal."
	},
	{
		"speaker": "B",
		"text": "Biaya produksi naik."
	},
	{
		"speaker": "A",
		"text": "Kasihan petani dan pedagang."
	},
	{
		"speaker": "B",
		"text": "Semua terdampak."
	},
	{
		"speaker": "A",
		"text": "Harus ada solusi."
	},
	{
		"speaker": "B",
		"text": "Semoga segera stabil."
	},
	{
		"speaker": "A",
		"text": "Agar ekonomi pulih."
	},
	{
		"speaker": "B",
		"text": "Dan warga bisa tenang lagi."
	}
]

var current_dialog := 0


func _ready():

	npc_a.play("walk_side")
	npc_b.play("walk_side")

	npc_a.flip_h = false
	npc_b.flip_h = true

	bubble_a.visible = false
	bubble_b.visible = false

	show_dialog()


func show_dialog():

	bubble_a.visible = false
	bubble_b.visible = false

	var dialog = dialogs[current_dialog]

	if dialog["speaker"] == "A":

		label_a.text = dialog["text"]
		bubble_a.visible = true

	else:

		label_b.text = dialog["text"]
		bubble_b.visible = true

	current_dialog += 1

	if current_dialog >= dialogs.size():
		current_dialog = 0

func _on_timer_timeout():
	show_dialog()
