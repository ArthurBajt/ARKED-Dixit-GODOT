extends Control


var id: int = 0

onready var labelNom = $LabelNom


onready var couleur = $HBoxContainer2/VBoxContainer/Couleur


func _ready():
	Network.connect("joueurChangeCouleur", self, "on_joueurChangeCouleur")


func setId(id: int):
	self.id = id
	$SymboleHote.visible = id == 1


func setNom(nom: String):
	self.labelNom.text = nom


func setCouleur(coul):
	self.couleur.color = coul


func on_joueurChangeCouleur(id: int, coul: Color):
	if self.id == id:
		self.setCouleur(coul)
