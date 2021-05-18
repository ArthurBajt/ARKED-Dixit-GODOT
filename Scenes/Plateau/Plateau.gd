extends Spatial

var joueurs: Array
var estHote: bool
var indexConteur: int = -1

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
	Network.connect("vote", self, "voteMoment")
	Network.connect("voirRes", self, "voirRes")


func init(joueursDeLaPartie: Array, cartesMax: int = 6):
	joueurs = joueursDeLaPartie
	estHote = Network.id == 1
	_initPioche()
	nbCarteJoueur = 6
	
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
	self.changeConteur()

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
	for child in rootCartes.get_children():
		print(child)
		child.positionCible.x += 0.28
	self.rootCartes.add_child(carte)
	
	if transform != null:
		carte.global_transform = transform
	
	carte.rotation_degrees.x = 0
	carte.rotation_degrees.y = 0
	carte.rotation_degrees.z = 180
	carte.positionCible = Vector3(0.28, 0, 0) * -(self.cartes.size() - 1)
	
	carte.estDansMain = false
	carte.estSurPlateau =  true
	carte.cache = true

func voteMoment():
	
	#Mélange des cartes
#	self.cartes.shuffle()
#	for carte in self.cartes:
#		carte.positionCible = Vector3(0,0,1)
#		yield(get_tree().create_timer(0.5), "timeout")
#
#	var i = 0
#	var cartePosees = []
#	for carte in self.cartes:
#		for cartezer in cartePosees:
#			cartezer.positionCible.x += 0.28
#		carte.positionCible = Vector3(0.28, 0, 0) * -(i)
#		cartePosees.append(carte)
#		i+=1
#		yield(get_tree().create_timer(0.8), "timeout")
	
	#retourner les cartes
	for child in self.cartes:
		yield(get_tree(), "idle_frame")
		child.setVisible(true)

func voirRes():
	for j in self.joueurs:
		j.voirRes()
	
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
	self.indexConteur = (self.indexConteur + 1) % self.joueurs.size()
	Network.changeConteur(self.joueurs[self.indexConteur].id)

func setTheme(themezer):
	self.theme = themezer
	Network.verifEtat(Globals.EtatJoueur.ATTENTE_SELECTIONS)
	
func getTheme():
	return self.theme
	
func nouvelleManche():
	print("nouvelle manche plateau")
	for carte in self.cartes:
		carte.queue_free()
	self.cartes = []
	
	for j in self.joueurs:
		j.nouvelleManche()
		self.pioche.piocher(j)
	
	if(Network.id == 1):
		self.changeConteur()
	
