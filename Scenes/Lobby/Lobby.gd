extends Node

const NODE_INFOJOUEUR = preload("res://Scenes/Lobby/InfoJoueur.tscn")

onready var layoutJoueur = $Control/HBoxContainer/LayoutJoueur

onready var buttonPret = $Control/HBoxContainer/LayoutBtn/ButtonPret
onready var buttonLancer = $Control/HBoxContainer/LayoutBtn/ButtonLancer

var peutLancer: bool = false

var joueurs: Dictionary = {}

func _ready():
	Network.connect("partieLancee", self, "_versPartie")
	Network.connect("nvUtilisateur", self, "joueurCo")
	Network.connect("nvStatuUtilisateur", self, "joueurNvStatut")
	buttonLancer.visible = Network.id == 1
	
	self.recupereJoueurs()

#==============================
func recupereJoueurs():
	for usId in Network.utilisateurs :
		if not usId in self.joueurs.keys():
			self.joueurCo(usId)


func joueurCo(idJoueur):
	if not idJoueur in self.joueurs.keys() :
		var instance = self.NODE_INFOJOUEUR.instance()
		self.joueurs[idJoueur] = instance
		self.layoutJoueur.add_child(instance)
		instance.setId(idJoueur)
		instance.setNom( Network.utilisateurs[idJoueur].nom )
		instance.setPret( Network.utilisateurs[idJoueur].estPret )
	self.majPeutLancer()


func joueurNvStatut(idJoueur, statut):
	if idJoueur in self.joueurs.keys():
		self.joueurs[idJoueur].setPret(statut)
	self.majPeutLancer()

func majPeutLancer():
	self.peutLancer = true
	for usId in Network.utilisateurs:
		self.peutLancer = self.peutLancer and Network.utilisateurs[usId].estPret
#		print("majPeutLancer - ", usId, " - ", Network.utilisateurs[usId].estPret)
	
	if self.peutLancer:
		self.buttonLancer.modulate = Color(1.0, 1.0, 1.0)
		self.buttonLancer.disabled = false
	else:
		self.buttonLancer.modulate = Color(1.0, 0.0, 0.0)
		self.buttonLancer.disabled = true

#==============================
func _on_ButtonPret_pressed():
	Network.lobby_setStatu(!Network.data.estPret)


func _on_ButtonLancer_pressed():
	if Network.id == 1 and self.peutLancer:
		Network.lobby_lancerPartie()


func _versPartie():
	Transition.transitionVers("res://Scenes/Partie/Partie.tscn")
