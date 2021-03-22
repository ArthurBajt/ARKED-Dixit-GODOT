extends Spatial
class_name Joueur

var id: int
var estLocal: bool = false

onready var camera: Camera = $Camera


func _ready():
	pass


func init(idJoueur: int):
	self.id = idJoueur
	self.estLocal = Network.id == idJoueur
#	camera.current = self.estLocal
