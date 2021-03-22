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
		utilisateursText += "\t" + "id: " + str(usId)
		if "estPret" in Network.utilisateurs[usId]:
			utilisateursText += "\t" + "estPret: " + str(Network.utilisateurs[usId].estPret) + "\n"
		utilisateursText += "\n\n"
	labelUtilisateurs.text = utilisateursText
