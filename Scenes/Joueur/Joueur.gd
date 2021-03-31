extends Spatial
class_name Joueur

var id: int
var estLocal: bool = false

var plateau
var main: Array
onready var mainRoot = $CameraPos/MainRoot

onready var cameraPos: Spatial = $CameraPos

const NODE_CAM = preload("res://Scenes/Joueur/CameraJoueur.tscn")
const NODE_UI = preload("res://Scenes/Joueur/UiJoueur.tscn")

const NODE_CARTE = preload("res://Scenes/Carte/Carte.tscn")

func _ready():
	pass


func init(idJoueur: int, plateauDePartie):
	self.id = idJoueur
	self.estLocal = Network.id == idJoueur
	self.plateau = plateauDePartie
	self.main = []
	
	if self.estLocal:
		var cam: Camera = NODE_CAM.instance()
		cameraPos.add_child(cam)
		cam.set_current(true)
		
		var ui= NODE_UI.instance()
		self.add_child(ui)


func piocheCarte(nomCarte: String):
	var instanceCarte = NODE_CARTE.instance()
	mainRoot.add_child(instanceCarte)
	instanceCarte.init(nomCarte, estLocal(), estLocal())
	main += [instanceCarte]
	
	instanceCarte.positionCible = Vector3(0.7*(main.size()-1), 0, 0)
	
	if estLocal:
		instanceCarte.connect("carteCliquee", self, "localPoseCarte")


func localPoseCarte(carte):
	Network.posercarte(self.id, carte.name)





#================
#	getters et trucs utiles toi même tu sais

func getCarte(nom: String):
	for c in self.main:
		if c.name == nom:
			return c
	return null


func estLocal()-> bool:
	""" Renvoie si les joueur est local (aka le joueur que les client est) """
	return self.id == Network.id


func retireCarte(carte: Carte):
	if carte in self.main:
		self.main.erase(carte)
		self.mainRoot.remove_child(carte)
