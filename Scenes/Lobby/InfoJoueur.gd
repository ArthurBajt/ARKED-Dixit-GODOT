class_name InfoJoueur
extends Panel

var id: int = 0

onready var led = $HBoxContainer/VBoxContainer/LedPret
const LED_TEXTURE_PRET = "res://Assets/Sprites/Led/led_green.png"
const LED_TEXTURE_PAS_PRET = "res://Assets/Sprites/Led/led_red.png"

onready var labelNom = $HBoxContainer/LabelNom
onready var labelPret = $HBoxContainer/LabelPret

onready var couleur = $HBoxContainer/HBoxContainer2/VBoxContainer/Couleur


func _ready():
	Network.connect("joueurChangeCouleur", self, "on_joueurChangeCouleur")


func setId(id: int):
	self.id = id
	$HBoxContainer/SymboleHote.visible = id == 1


func setNom(nom: String):
	self.labelNom.text = nom


func setCouleur(coul):
	self.couleur.modulate = coul


func setPret(etat: bool):
	if etat:
		self.led.texture = load(self.LED_TEXTURE_PRET)
		self.labelPret.text = R.getString("lobbyPret")
		self.labelPret.modulate = Color(0.0, 1.0, 0.0)
		$AudioStreamPlayer.play(0.0)
	
	else:
		self.led.texture = load(self.LED_TEXTURE_PAS_PRET)
		self.labelPret.text = R.getString("lobbyPasPret")
		self.labelPret.modulate = Color(1.0, 0.0, 0.0)


func on_joueurChangeCouleur(id: int, coul: Color):
	if self.id == id:
		self.setCouleur(coul)
