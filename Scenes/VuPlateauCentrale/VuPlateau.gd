extends Spatial

var plateau

var id: int
onready var cameraPos: Spatial = $Spat

onready var CAM = get_node("/root/Partie/Scene/Camera")
#const NODE_CAM = preload("res://Scenes/Joueur/CameraJoueur.tscn")
const NODE_CARTE = preload("res://Scenes/Carte/Carte.tscn")
var estConteur: bool = false 
var ui 
var uiConteur
var myCam

var etat: int
	
func _ready():
	pass
	"""Network.connect("ChangementConteur", self, "setConteur")
	Network.connect("updateTheme",self,"changeTheme")
	Network.connect("APoseCarte",self,"carteSelectectionnee")"""



func init(idJoueur: int, plateauDePartie):
	self.id = idJoueur
	self.plateau = plateauDePartie
	#self.etat = Globals.EtatJoueur.ATTENTE_CHOIX_THEME
	self.myCam = null
	# UI dans le joueur car c'est celui qui est en local qui en a besoin
	"""self.add_child(uiConteur)
	self.add_child(ui)
	self.myCam = cam"""
	CAM.current = true

