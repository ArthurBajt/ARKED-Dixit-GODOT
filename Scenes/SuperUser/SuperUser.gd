extends Control


onready var layoutJoueur = $VBoxContainer/LayoutJoueurs

onready var NODE_INFOJOUEURSU = preload("res://Scenes/SuperUser/InfoUserSU.tscn")

var joueurs: Dictionary = {}

func _ready():
	Network.connect("nvUtilisateur", self, "joueurCo")
	Network.connect("decoJoueur", self, "decoJoueur")
	Network.connect("joueurChangeCouleur", self, "on_joueurChangeCouleur")

	recupereJoueurs()

#==============================
func recupereJoueurs():
	for usId in Network.utilisateurs:
		if not usId in self.joueurs.keys():
			self.joueurCo(usId)


func joueurCo(idJoueur):
	if not idJoueur in self.joueurs.keys() :
		var instance = self.NODE_INFOJOUEURSU.instance()
		self.joueurs[idJoueur] = instance
		self.layoutJoueur.add_child(instance)
		instance.setId(idJoueur)
		instance.setNom( Network.utilisateurs[idJoueur].nom )
		instance.setCouleur( Network.utilisateurs[idJoueur].couleur )



func decoJoueur(idJoueur):

	if idJoueur in self.joueurs.keys():
		self.layoutJoueur.remove_child(self.joueurs[idJoueur])
		self.joueurs.erase(idJoueur)

