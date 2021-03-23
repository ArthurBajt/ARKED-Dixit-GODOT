extends Spatial
class_name Joueur

var id: int
var estLocal: bool = false

var plateau
var main: Array

onready var cameraPos: Spatial = $CameraPos

const NODE_UI = preload("res://Scenes/Joueur/UiJoueur.tscn")



func init(idJoueur: int, plateauDePartie):
	self.id = idJoueur
	self.estLocal = Network.id == idJoueur
	self.plateau = plateauDePartie
	self.main = []
	
	if self.estLocal:
		var cam: Camera = Camera.new()
		cameraPos.add_child(cam)
		cam.set_current(true)
		
		var ui= NODE_UI.instance()
		self.add_child(ui)

