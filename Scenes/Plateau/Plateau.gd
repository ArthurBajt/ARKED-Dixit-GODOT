extends Spatial

var joueurs: Array
var estHote: bool
var indexConteur: int = 0

var pioche: Pioche
const NODE_PIOCHE_CLIENT = preload("res://Scenes/Pioche/PiocheClient.tscn")
const NODE_PIOCHE_HOTE = preload("res://Scenes/Pioche/PiocheHote.tscn")

var nbCarteJoueur: int

var theme: String = ""

onready var mesh = $Mesh
onready var rootCartes = $RootCartes

var cartes: Array = []

func _ready():
	Network.connect("joueurApiocherCarte", self, "_on_joueurApiocherCarte")
	Network.connect("JoueurPoseCarte", self, "_fairePoserCarte")


func init(joueursDeLaPartie: Array, cartesMax: int = 6):
	joueurs = joueursDeLaPartie
	estHote = Network.id == 1
	_initPioche()
	nbCarteJoueur = min(joueurs.size() +2, cartesMax)
	
	if estHote:
		Network.connect("JoueursDansPartie", self, "lancePartie")


func _initPioche():
	var nodePioche
	if Network.id == 1:
		nodePioche = NODE_PIOCHE_HOTE.instance()
	else:
		nodePioche = NODE_PIOCHE_CLIENT.instance()
	
	self.add_child(nodePioche)
	pioche = nodePioche

func lancePartie():
	distribuCarte()
	Network.changeConteur(self.joueurs[0].id)

func distribuCarte():
	for j in joueurs:
		for _i in range(0, nbCarteJoueur):
			pioche.piocher(j)


func _on_joueurApiocherCarte(idJoueur: int, carte:String):
	var j = getJoueur(idJoueur)
	j.piocheCarte(carte)


func JoueurPosecarte(idJoueur: int, nomCarte: String):
	pass


func _fairePoserCarte(idJoueur: int, nomCarte: String):
	var j: Joueur= getJoueur(idJoueur)
	var carte = j.getCarte(nomCarte)
	
	if carte != null and j != null:
		var transformCarte = carte.get_global_transform()
		j.retireCarte(carte)
		self.ajouteCartePlateau(carte, transformCarte)


func ajouteCartePlateau(carte: Carte, transform = null):
	self.cartes.append(carte)
	self.rootCartes.add_child(carte)
	
	if transform != null:
		carte.global_transform = transform
	
	carte.positionCible = Vector3(1, 0, 0) * (self.cartes.size() -1)
	

#================
#	getters et trucs utiles toi même tu sais
func getJoueur(id: int):
	for j in joueurs:
		if j.id == id:
			return j
	return null

#================
#	Conteur

func changeConteur():
	indexConteur+=1 % joueurs.size()
	Network.changeConteur(indexConteur)

func setTheme(themezer):
	self.theme = themezer
	
func getTheme():
	return self.theme
