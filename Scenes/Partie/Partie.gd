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

	Network.connect("decoJoueur", self, "decoJoueur")

	Network.connect("voirRes", self, "affichePoseurs")
	Network.connect("giveVoteurs",self, "afficheVoteurs")
	Network.connect("prochaineManche", self, "nouvelleManche")

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

func decoJoueur(idJoueur):
	for joueur in nodeJoueurs.get_children():
		if joueur != null:
			if joueur.getId()==idJoueur:
				joueur.queue_free()
				
	for joueur in joueurs: 
		if joueur.getId()==idJoueur:
			joueurs.erase(joueur)


func PionJoueur(idJoueur, ScX,ScY,ScZ,PosX, PosY, PosZ, rX, rY, rZ):
	for joueur in nodeJoueurs.get_children():
		if joueur != null:
			if joueur.getId()==idJoueur:
				var pion=joueur.get_node("MeshRoot").duplicate()

				pion.set_scale(Vector3(ScX,ScY,ScZ))
				pion.transform.origin.x=PosX
				pion.transform.origin.y=PosY
				pion.transform.origin.z=PosZ

				$Scene/Pions.add_child(pion)
				
				pion.rotation.x = 0
				pion.rotation.y = 0
				pion.rotation.z = 0
				pion.rotation_degrees.x = rX
				pion.rotation_degrees.y = rY
				pion.rotation_degrees.z = rZ
				return pion

func affichePoseurs():
	print("Devrait afficher les poseurs")
	for carte in plateau.cartes:
		var jId
		for j in Network.data.cartesPlateau:
			if(Network.data.cartesPlateau[j] == carte.nom):
				jId = j
		PionJoueur(jId,0.05,0.05,0.05,carte.global_transform.origin.x,carte.global_transform.origin.y,carte.global_transform.origin.z+0.3,0.0,90,90)

func afficheVoteurs(nomCarte,votants):
	for carte in plateau.cartes:
		if carte.nom == nomCarte:
			var pion
			for jId in votants:
				pion = PionJoueur(jId,0.05,0.05,0.05,carte.positionCible.x,carte.positionCible.y+0.01,carte.positionCible.z,0.0,90,0.0)
				carte.AjoutePion(pion)

func clearPions():
	for pion in $Scene/Pions.get_children():
		pion.queue_free()

func nouvelleManche():
	self.clearPions()
	plateau.nouvelleManche()
