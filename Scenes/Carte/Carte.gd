extends Spatial
class_name Carte

var nom: String
var texture

var estVisible: bool setget setVisible

var positionCible: Vector3


onready var mesh: Spatial = $Mesh
onready var verso: MeshInstance = $Mesh/CarteVerso


var peutEtreHover: bool = false setget setPeutEtreHover
var hover: bool = false


func _ready():
	pass


func _process(delta):
	if self.translation != positionCible:
		self.translation = lerp(self.translation, positionCible, 5*delta)
	
	if self.peutEtreHover and self.hover:
		mesh.translation = lerp(mesh.translation, Vector3(0, 0.08, 0), 5*delta)
	else:
		mesh.translation = lerp(mesh.translation, Vector3.ZERO, 3*delta)


func init(nom, visible: bool = true, estHover: bool= true, positionDepart: Vector3 = Vector3.ZERO, positionCible: Vector3 = Vector3.ZERO):
	self.nom = nom
	self.texture = R.getCarte(nom)
	self.translation = positionDepart
	
	setVisible(visible)
	setPeutEtreHover(estHover)


func setVisible(val: bool):
	""" Rend la carte visible pour le client. 
	Visible --> On voit la vraie texture de la carte.
	!Visible --> On voit la texture par defaut de la carte. """
	
	estVisible = val
	var txt = self.verso.get_surface_material(0).duplicate()
	
	if self.estVisible:
		txt.albedo_texture = self.texture
	
	else:
		txt.albedo_texture = R.getCarteDefaut()
	
	self.verso.set_surface_material(0, txt)


func setPeutEtreHover(val: bool):
	peutEtreHover = val


# Si on survole la carte
func _on_Area_mouse_entered():
	hover = true

func _on_Area_mouse_exited():
	hover = false

# si on clique sur la carte
signal carteCliquee(laCarte)
func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			print("la carte : ", self.name, " a ete cliquée !")
			emit_signal("carteCliquee", self)
