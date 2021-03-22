extends Spatial
class_name Joueur

var id: int
var estLocal: bool = false

var plateau

onready var cameraPos: Spatial = $CameraPos

const NODE_UI = preload("res://Scenes/Joueur/UiJoueur.tscn")



func init(idJoueur: int, plateauDePartie):
	self.id = idJoueur
	self.estLocal = Network.id == idJoueur
	self.plateau = plateauDePartie
	
	if self.estLocal:
		var cam: Camera = Camera.new()
		cameraPos.add_child(cam)
		cam.set_current(true)
#		cam.global_transform = cameraPos.global_transform
		
		var ui= NODE_UI.instance()
		self.add_child(ui)

