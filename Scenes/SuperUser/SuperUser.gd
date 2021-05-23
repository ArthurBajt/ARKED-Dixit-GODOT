extends Control


onready var layoutJoueur = $VBoxContainer/LayoutJoueurs
onready var NbPoint = $changePoint/LayoutPoint/NbPoint
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



func decoJoueur(idJoueur, NomCarte, eraseCarte):

	if idJoueur in self.joueurs.keys():
		self.layoutJoueur.remove_child(self.joueurs[idJoueur])
		self.joueurs.erase(idJoueur)


func _on_ButtonPointPrec_pressed():
	var nbPoints = int(NbPoint.text)
	if nbPoints <=10:
		NbPoint.set_text("100")
	else:
		nbPoints-=5
		NbPoint.set_text(String(nbPoints))
		
	Network.changeObjectif(int(NbPoint.text))
	
func _on_ButtonPointSuiv_pressed():
	var nbPoints = int(NbPoint.text)
	if nbPoints >=100:
		NbPoint.set_text("10")
	else:
		nbPoints+=5
		NbPoint.set_text(String(nbPoints))
	Network.changeObjectif(int(NbPoint.text))
