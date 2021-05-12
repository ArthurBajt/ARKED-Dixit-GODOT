extends Node


onready var nodeJoueurs = $Scene/Joueurs
var joueurs: Array = []
const JOUEUR_INSTANCE = preload("res://Scenes/Joueur/Joueur.tscn")
const JOUEUR_POSITION: Vector3 = Vector3(0, 0, -4)

onready var plateau = $Scene/Plateau

export(String, FILE, "*.ogg") var musiquePath


func _ready():
	Music.setMusic(self.musiquePath)
	_instancierJoueurs()
	_placerJoueurs()
	plateau.init(joueurs)
	
	Network.partie_setChargee()

class TrieJoueurs:
	# c'est comme les fonctions discrettes en js.
	# mais en beaucoup moins bien fait
	static func sort(a, b):
		return a.id < b.id

func _instancierJoueurs():
	""" """
	for usId in Network.utilisateurs:
		var j = JOUEUR_INSTANCE.instance()
		

		nodeJoueurs.add_child(j)
		j.init(usId, plateau, Network.utilisateurs[usId].couleur)
		joueurs.append(j)
	
	joueurs.sort_custom(TrieJoueurs, "sort")
	

func _placerJoueurs():
	""" """
	var nbJoueurs = len(joueurs)
	var angle = 0.0
	for j in joueurs:
		j.translation = JOUEUR_POSITION.rotated(Vector3.UP, deg2rad( angle ))
		j.rotation = Vector3(0, deg2rad( angle ), 0)
		angle += 360 / nbJoueurs

func PionJoueur(idJoueur, ScX,ScY,ScZ,PosX, PosY, PosZ, rX, rY, rZ):
	for joueur in nodeJoueurs.get_children():
		if joueur != null:
			if joueur.getId()==idJoueur:
				var pion=joueur.get_node("MeshRoot").duplicate()

				pion.set_scale(Vector3(ScX,ScY,ScZ))
				pion.transform.origin.x=PosX
				pion.transform.origin.y=PosY
				pion.transform.origin.z=PosZ
				pion.rotate_x(rX)
				pion.rotate_x(rY)
				pion.rotate_x(rZ)

				$Scene/Pions.add_child(pion)

func clearPions():
	for pion in $Scene/Pions:
		pion.queue_free()
