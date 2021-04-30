extends Node

onready var buttonPret = $Control/VBoxContainer/ButtonPret
onready var buttonLancer = $Control/VBoxContainer/ButtonLancer

var estPret: bool

func _ready():
	Network.connect("partieLancee", self, "_versPartie")
	buttonLancer.visible = Network.id == 1
	self.estPret = false
	adaptTextButtonPret()

func _on_ButtonPret_pressed():
	Network.lobby_setStatu(!Network.data.estPret)
	self.estPret = !self.estPret
	adaptTextButtonPret()


func _on_ButtonLancer_pressed():
	Network.lobby_lancerPartie()


func _versPartie():
	Transition.transitionVers("res://Scenes/Partie/Partie.tscn")

func adaptTextButtonPret():
	if(self.estPret):
		buttonPret.text = "Prêt"
		buttonPret.modulate = "10ff26"
		#10ff26
	else:
		buttonPret.text = "Pas prêt"
		buttonPret.modulate = "ff8010"
		#ff8010
