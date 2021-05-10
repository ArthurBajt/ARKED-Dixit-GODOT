extends Node

onready var camRoot = $"3dRoot/CamRoot"
var vitesseRotation = 0.02

export(String, FILE, "*.ogg") var musiquePath

func _ready():
	initUi()
	Music.setMusic(self.musiquePath)

func _physics_process(delta):
	self.camRoot.rotation.y += self.vitesseRotation * delta

func _input(event):  # On check au début si c'est un tel ou un pc
	"""if event is InputEventMouseButton:
		Globals.isMobile = false
		print("pc détecté")
		print(Globals.isMobile)"""
	if event is InputEventScreenTouch:
		Globals.isMobile = true
		print("telephone détecté")
		print(Globals.isMobile)

func initUi():
	$Ui/Titre.text = R.getString("titreJeu")
	$Ui/Copyright.text = R.getString("copyright")
	
	$Ui/BtnJouer.text = R.getString("btnJouer")
	$Ui/BtnOptions.text = R.getString("btnOptions")
	$Ui/BtnQuit.text = R.getString("btnQuitter")

#==================
#	Sigaux

func _on_BtnJouer_pressed():
	Transition.transitionVers("res://Scenes/Menu/Menu.tscn")


func _on_BtnOptions_pressed():
	Globals.optionAffiche()


func _on_BtnQuit_pressed():
	Globals.quitter()
