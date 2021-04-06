extends Node

onready var labelId = $UI/LabelId
onready var labelUtilisateurs = $UI/labelUtilisateurs

func _ready():
	print(Network.dataStruct)
	pass


func _process(_delta):
	labelId.text = "ID : " + str(Network.id)
	
	var utilisateursText = "Utilisateur(s) :\n"
	for usId in Network.utilisateurs:
		utilisateursText += "\t" + "pseudo: " + str(Network.utilisateurs[usId].nom)
		utilisateursText += "\t" + "id: " + str(usId)
		if "estPret" in Network.utilisateurs[usId]:
			utilisateursText += "\n\t" + "estPret: " + str(Network.utilisateurs[usId].estPret)
			
		if "main" in Network.utilisateurs[usId]:
			utilisateursText += "\n\t" + "main: " + str(Network.utilisateurs[usId].main)
		
		if "estDansPartie" in Network.utilisateurs[usId]:
			utilisateursText += "\n\t" + "estDansPartie: " + str(Network.utilisateurs[usId].estDansPartie)
		
		utilisateursText += "\n\n\n"
	labelUtilisateurs.text = utilisateursText
