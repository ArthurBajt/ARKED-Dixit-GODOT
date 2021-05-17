extends Spatial
class_name Joueur

var id: int
var estLocal: bool = false

var plateau
var main: Array
var carteVotee: Carte
onready var mainRoot = $CameraPos/MainRoot

onready var cameraPos: Spatial = $CameraPos



onready var matiereTete=$MeshRoot/Head.get_surface_material(0)
onready var matiereCorps=$MeshRoot/Body.get_surface_material(0)
onready var matiereChapeau=$MeshRoot/MeshInstance3.get_surface_material(0)


onready var tete=$MeshRoot/Head
onready var corps=$MeshRoot/Body
onready var chapeau=$MeshRoot/MeshInstance3

onready var CAM_MID = get_node("/root/Partie/Scene/Camera")
const NODE_CAM = preload("res://Scenes/Joueur/CameraJoueur.tscn")
const NODE_UI = preload("res://Scenes/Joueur/UiJoueur.tscn")
const NODE_UI_CONTEUR = preload("res://Scenes/Joueur/UiConteur.tscn")
const NODE_CHAT = preload("res://Scenes/Chat/Chat.tscn")

const NODE_CARTE = preload("res://Scenes/Carte/Carte.tscn")
var estConteur: bool = false 
var ui 
var uiConteur
var uiChat: Chat
var myCam

var etat: int
	
func _ready():
	Network.connect("ChangementConteur", self, "setConteur")
	Network.connect("updateTheme",self,"changeTheme")
	Network.connect("APoseCarte",self,"carteSelectectionnee")
	Network.connect("vote",self,"peuxVoter")
	Network.connect("voirRes",self,"voirRes")
	Network.connect("carteVotee", self, "aVote")



func init(idJoueur: int, plateauDePartie):
	self.id = idJoueur
	self.estLocal = Network.id == idJoueur
	self.plateau = plateauDePartie
	self.main = []
	self.estConteur = false
	self.etat = Globals.EtatJoueur.ATTENTE_CHOIX_THEME
	self.myCam = null

	
	
	if self.estLocal():
		var cam: Camera = NODE_CAM.instance()
		cameraPos.add_child(cam)
		cam.set_current(true)
		# UI dans le joueur car c'est celui qui est en local qui en a besoin
		self.uiConteur = NODE_UI_CONTEUR.instance()
		self.add_child(uiConteur)
		self.ui = NODE_UI.instance()
		self.add_child(ui)
		self.uiChat = NODE_CHAT.instance()
		self.add_child(uiChat)
		self.myCam = cam
		
		self.uiConteur.attendreChoixConteur()
		
		matiereTete.set_albedo(Network.couleurJoueurLocal(id))
		matiereChapeau.set_albedo(Network.couleurJoueurLocal(id))
		matiereCorps.set_albedo(Network.couleurJoueurLocal(id))
		corps.set_surface_material(0,matiereCorps)
		tete.set_surface_material(0,matiereTete)
		chapeau.set_surface_material(0,matiereChapeau)

func _input(event):
	# Pour changer de cam lorsque l'on utilise les fleches
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_UP:
			if(self.myCam.current == true):
				self.myCam.current = false
				CAM_MID.current = true
		if event.pressed and event.scancode == KEY_DOWN:
			if(self.CAM_MID.current == true):
				CAM_MID.current = false
				self.myCam.current = true

#func _process(delta):
#	if(estLocal()):
#
#		print("----i----")
#		print("moi c'est ", id)
#		print("Mon etat est : ", self.etat)
#		print("Mon etat network est : ", Network.utilisateurs[id].etat)


		
#		if(self.etat == Globals.EtatJoueur.SELECTION_CARTE_THEME):
#			self.uiConteur.enlever()
#		if(self.etat == Globals.EtatJoueur.CHOIX_THEME):
#			self.uiConteur.afficheUiConteur(self.estConteur)
#		if(self.etat == Globals.EtatJoueur.ATTENTE_CHOIX_THEME):
#			self.uiConteur.attendreSelections()
#		if(self.etat == Globals.EtatJoueur.SELECTION_CARTE):
#			self.uiConteur.enlever()
#		if(self.etat == Globals.EtatJoueur.ATTENTE_SELECTIONS):
#			self.uiConteur.attendreSelections()
#		if(self.etat == Globals.EtatJoueur.VOTE):
#			print("Je vote")
#			self.uiConteur.enlever()
#		if(self.etat == Globals.EtatJoueur.ATTENTE_VOTES):
#			self.uiConteur.attendreVotes()
#		if(self.etat == Globals.EtatJoueur.VOIR_RESULTAT):
#			self.uiConteur.enlever()
		
func piocheCarte(nomCarte: String):
	var instanceCarte = NODE_CARTE.instance()
	mainRoot.add_child(instanceCarte)
	instanceCarte.init(nomCarte, estLocal(), estLocal())
	main += [instanceCarte]
	
	instanceCarte.positionCible = Vector3(-0.6+0.5*(main.size()-1), 0, 0)
	
	if estLocal:
		instanceCarte.connect("carteCliquee", self, "localPoseCarte")
	
	instanceCarte.estDansMain = true
	instanceCarte.estSurPlateau =  false


func localPoseCarte(carte):
	
	if(!self.estConteur):
		self.uiConteur.attendreSelections()
		self.etat = Globals.EtatJoueur.ATTENTE_SELECTIONS
	else:
		self.uiConteur.afficheUiConteur()
		self.etat= Globals.EtatJoueur.CHOIX_THEME
		
	Network.posercarte(self.id, carte.nom)
	carte.disconnect("carteCliquee", self, "localPoseCarte")
	carte.peutEtreHover = false
	Network.verifEtat(Globals.EtatJoueur.ATTENTE_SELECTIONS)

#================
#	getters et trucs utiles toi même tu sais

func getCarte(nom: String):
	for c in self.main:
		if c.nom == nom:
			return c
	return null


func estLocal()-> bool:
	""" Renvoie si le joueur est local (aka le joueur que les client est) """
	return self.id == Network.id


func retireCarte(carte: Carte):
	if carte in self.main:
		self.main.erase(carte)
		self.mainRoot.remove_child(carte)
		

# ===========
# UI
func setConteur(idJoueur):
	self.estConteur = self.id == idJoueur
	if(self.estConteur):
		self.etat = Globals.EtatJoueur.SELECTION_CARTE_THEME
		if(self.estLocal()):
			self.uiConteur.enlever()
	else:
		if(self.estLocal()):
				self.uiConteur.attendreChoixConteur()
		self.etat = Globals.EtatJoueur.ATTENTE_CHOIX_THEME
		
func changeTheme(theme, nomConteur):
	if(self.estConteur):
		self.etat = Globals.EtatJoueur.ATTENTE_SELECTIONS
	else:
		self.etat = Globals.EtatJoueur.SELECTION_CARTE
	if estLocal():
		if(self.estConteur):
			self.ui.changeTheme(theme)
			self.uiConteur.attendreSelections()
		else:
			self.ui.changeTheme(theme, false, nomConteur)
			self.uiConteur.enlever()

func carteSelectectionnee(idJoueur):
	# Si le joueur a bien posé la carte et qu'il est local
	if(self.id == idJoueur):
		# Alors si il est conteur
		if(self.estConteur):
			# On lui demande le choix du theme
			self.etat = Globals.EtatJoueur.CHOIX_THEME
		else:
			# Sinon il attends le conteur
			self.etat = Globals.EtatJoueur.ATTENTE_SELECTIONS
		Network.verifEtat(Globals.EtatJoueur.ATTENTE_SELECTIONS)

func peuxVoter():
	print("Suis je conteur ? ", self.id, self.estConteur)
	if(self.estConteur):
		self.etat = Globals.EtatJoueur.ATTENTE_VOTES
		if(estLocal()):
			self.uiConteur.attendreVotes()
	else:
		
		
		self.etat = Globals.EtatJoueur.VOTE
		if(estLocal()):
			
			print("pouet")
			
			self.uiConteur.enlever()
	if(estLocal()):
		self.myCam.current = false
		CAM_MID.current = true
	Network.verifEtat(Globals.EtatJoueur.ATTENTE_VOTES)
	

func aVote(nomCarte, idJoueur):
	print(idJoueur, " : ", self.id)
	if(idJoueur == self.id):
		self.carteVotee = nomCarte
		self.etat = Globals.EtatJoueur.ATTENTE_VOTES
		if(self.estLocal()):
			self.uiConteur.attendreVotes()
		Network.verifEtat(Globals.EtatJoueur.ATTENTE_VOTES)
	
func voirRes():
	self.etat = Globals.EtatJoueur.VOIR_RESULTAT
	if(estLocal()):
		self.uiConteur.enlever()
	# Attribution des points

func PionJoueur(ScX,ScY,ScZ,PosX, PosY, PosZ, rX, rY, rZ):
	var mesh=$MeshRoot.duplicate()
	self.add_child(mesh)


	mesh.set_scale(Vector3(ScX,ScY,ScZ))
	mesh.transform.origin.x=PosX
	mesh.transform.origin.y=PosY
	mesh.transform.origin.z=PosZ
	mesh.rotate_x(rX)
	mesh.rotate_x(rY)
	mesh.rotate_x(rZ)


