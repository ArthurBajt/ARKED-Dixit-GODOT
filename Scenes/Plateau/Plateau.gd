extends Spatial


var joueurs: Array
var estHote: bool

var pioche: Pioche
const NODE_PIOCHE_CLIENT = preload("res://Scenes/Pioche/PiocheClient.tscn")
const NODE_PIOCHE_HOTE = preload("res://Scenes/Pioche/PiocheHote.tscn")

var nbCarteJoueur: int

func _ready():
	Network.connect("joueurApiocherCarte", self, "_on_joueurApiocherCarte")


func init(joueursDeLaPartie: Array, cartesMax: int = 6):
	joueurs = joueursDeLaPartie
	estHote = Network.id == 1
	_initPioche()
	nbCarteJoueur = min(joueurs.size() +2, cartesMax)
	
	if estHote:
		Network.connect("JoueursDansPartie", self, "distribuCarte")


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
		for _i in range(0, nbCarteJoueur):
			pioche.piocher(j)


func _on_joueurApiocherCarte(idJoueur: int, carte:String):
	var j = getJoueur(idJoueur)
	j.piocheCarte(carte)

func getJoueur(id: int):
	for j in joueurs:
		if j.id == id:
			return j
	return null
