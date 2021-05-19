extends Node

onready var nodeUi = $UI
onready var labelId = $UI/LabelId
onready var labelUtilisateurs = $UI/labelUtilisateurs

func _ready():
	nodeUi.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _process(_delta):
	labelId.text = "ID : " + str(Network.id)
	
	var utilisateursText = "Utilisateur(s) :\n"
	for usId in Network.utilisateurs:
		utilisateursText += "\t" + "nom: " + str(Network.utilisateurs[usId].nom)
		utilisateursText += "\t" + "id: " + str(usId)
		if "estPret" in Network.utilisateurs[usId]:
			utilisateursText += "\n\t" + "estPret: " + str(Network.utilisateurs[usId].estPret)
			
		if "main" in Network.utilisateurs[usId]:
			utilisateursText += "\n\t" + "main: " + str(Network.utilisateurs[usId].main)
		
		if "estDansPartie" in Network.utilisateurs[usId]:
			utilisateursText += "\n\t" + "estDansPartie: " + str(Network.utilisateurs[usId].estDansPartie)
			
		if "estConteur" in Network.utilisateurs[usId]:
			utilisateursText += "\n\t" + "estConteur" + str(Network.utilisateurs[usId].estConteur)
		
		if "couleur" in Network.utilisateurs[usId]:
			utilisateursText += "\n\t" + "Couleur" + str(Network.utilisateurs[usId].couleur)
		
		
		utilisateursText += "\n\n\n"
	labelUtilisateurs.text = utilisateursText
	
