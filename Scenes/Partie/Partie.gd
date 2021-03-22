extends Node



#	Dictionary du type :
#		{id_utilisateur: Node_du_joueur}
onready var nodeJoueurs = $Scene/Joueurs
var joueurs: Array = []
const JOUEUR_INSTANCE = preload("res://Scenes/Joueur/Joueur.tscn")
const JOUEUR_POSITION: Vector3 = Vector3(0, 0, -5)




func _ready():
	_instancierJoueurs()
	_placerJoueurs()


func _instancierJoueurs():
	""" """
	for usId in Network.utilisateurs:
		var j = JOUEUR_INSTANCE.instance()
		
		
		nodeJoueurs.add_child(j)
		j.init(usId)
		joueurs.append(j)


func _placerJoueurs():
	""" """
	var nbJoueurs = len(joueurs)
	var angle = 0.0
	for j in joueurs:
		j.translation = JOUEUR_POSITION.rotated(Vector3.UP, deg2rad( angle ))
		j.rotation = Vector3(0, deg2rad( angle ), 0)
		angle += 360 / nbJoueurs
