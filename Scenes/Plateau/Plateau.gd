extends Spatial


var joueurs: Array
var estHote: bool

var pioche: Pioche
const NODE_PIOCHE_CLIENT = preload("res://Scenes/Pioche/PiocheClient.tscn")
const NODE_PIOCHE_HOTE = preload("res://Scenes/Pioche/PiocheHote.tscn")

var nbCarteJoueur: int


func init(joueursDeLaPartie: Array):
	joueurs = joueursDeLaPartie
	estHote = Network.id == 1
	_initPioche()
	nbCarteJoueur = joueurs.size()
	
	if Network.id == 1:
		distribuCarte()


func _initPioche():
	var nodePioche
	if Network.id == 1:
		nodePioche = NODE_PIOCHE_HOTE.instance()
	else:
		nodePioche = NODE_PIOCHE_CLIENT.instance()
	
	self.add_child(nodePioche)
	pioche = nodePioche


func distribuCarte():
	for j in joueurs:
		for i in range(0, nbCarteJoueur):
			pioche.piocher(j)
