class_name InfoJoueur
extends HBoxContainer

var id: int = 0

onready var led = $VBoxContainer/LedPret
const LED_TEXTURE_PRET = "res://Assets/Sprites/Led/led_green.png"
const LED_TEXTURE_PAS_PRET = "res://Assets/Sprites/Led/led_red.png"

onready var labelNom = $LabelNom
onready var labelPret = $LabelPret


func _ready():
	pass

func setId(id: int):
	self.id = id


func setNom(nom: String):
	self.labelNom.text = nom


func setPret(etat: bool):
	if etat:
		self.led.texture = load(self.LED_TEXTURE_PRET)
		self.labelPret.text = R.getString("lobbyPret")
		self.labelPret.modulate = Color(0.0, 1.0, 0.0)
	
	else:
		self.led.texture = load(self.LED_TEXTURE_PAS_PRET)
		self.labelPret.text = R.getString("lobbyPasPret")
		self.labelPret.modulate = Color(1.0, 0.0, 0.0)
