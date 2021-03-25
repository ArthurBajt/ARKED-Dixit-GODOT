extends Spatial
class_name Carte

var nom: String
var texture

var estVisible: bool

var positionCible: Vector3

onready var verso: MeshInstance = $Mesh/CarteVerso


func _process(delta):
	if self.translation != positionCible:
		self.translation = lerp(self.translation, positionCible, 5*delta)


func init(nom, visible: bool = true, positionDepart: Vector3 = Vector3.ZERO, positionCible: Vector3 = Vector3.ZERO):
	self.nom = nom
	self.texture = R.getCarte(nom)
	self.visible = visible
	
	self.translation = positionDepart
	
	if visible:
		var txt = self.verso.get_surface_material(0).duplicate()
		txt.albedo_texture = self.texture
		self.verso.set_surface_material(0, txt)
