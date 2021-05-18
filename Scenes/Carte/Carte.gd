extends Spatial
class_name Carte

var nom: String
var coef = 1
var bonus = 0
var malus = 0

var texture

var estVisible: bool setget setVisible

var positionCible: Vector3


onready var mesh: Spatial = $Mesh
onready var verso: MeshInstance = $Mesh/CarteVerso

onready var animation = $AnimationTree


var peutEtreHover: bool = false setget setPeutEtreHover
var hover: bool = false

var estDansMain: bool = false
var estSurPlateau: bool  = false
var cache: bool

var pionsDessus: Array = []

var joueurQuiAPose: int

func _ready():
	self.connect("carteVotee", Network, "voteCarte")


func _process(delta):
	if self.translation != positionCible:
		self.translation = lerp(self.translation, self.positionCible, 5*delta)
	
	if self.estDansMain:
		if self.peutEtreHover and self.hover:
			self.animation.setAnimationCible( "Hoover" )
		else:
			self.animation.setAnimationCible( "DansMain" )
	
	elif self.estSurPlateau:
		if self.cache:
			self.animation.setAnimationCible( "Cachee" )
		else:
			self.animation.setAnimationCible( "Decouverte" )

func init(nom, visible: bool = true, estHover: bool= true, positionDepart: Vector3 = Vector3.ZERO, positionCible: Vector3 = Vector3.ZERO):
	self.nom = nom
	self.texture = R.getCarte(self.nom)
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
	self.hover = true

func _on_Area_mouse_exited():
	self.hover = false

# si on clique sur la carte
signal carteCliquee(laCarte)
signal carteVotee(laCarte, idJoueur)

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			if(self.estDansMain):
				self.joueurQuiAPose = Network.id
				emit_signal("carteCliquee", self)
			if(self.estSurPlateau && self.joueurQuiAPose != Network.id):
				emit_signal("carteVotee", self, Network.id)
				
func AjoutePion(pion):
	for pion in self.pionsDessus:
		pion.transform.origin.z += 0.05
	
	self.pionsDessus.append(pion)
	
	
	pion.rotation_degrees.x = 0
	pion.rotation_degrees.y = 90
	pion.rotation_degrees.z = 0
	pion.transform.origin.x = self.global_transform.origin.x
	pion.transform.origin.y = self.global_transform.origin.y
	pion.transform.origin.z = self.global_transform.origin.z + (0.05 * -(self.pionsDessus.size() - 1))
