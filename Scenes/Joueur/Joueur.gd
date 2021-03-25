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
	instanceCarte.init(nomCarte)
	main += [instanceCarte]
	
	instanceCarte.positionCible = Vector3(0.7*(main.size()-1), 0, 0)
	print("piocheCarte ", id, " len: ", main.size())
	
