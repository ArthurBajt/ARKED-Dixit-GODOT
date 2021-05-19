extends Node

onready var camRoot = $"3dRoot/CamRoot"
onready var panelJouer = $Ui/LayoutPanelJouer/HBoxContainer/PanelJouer
var vitesseRotation = 0.02

export(String, FILE, "*.ogg") var musiquePath

func _ready():
	initUi()
	Music.setMusic(self.musiquePath)
	
	if Network.erreur_connexion != null:
		Globals.afficheErreur(Network.erreur_connexion)
		Network.erreur_connexion = null

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
	$Ui/LayoutTitre/HBoxContainer/Titre.text = R.getString("titreJeu")
	$Ui/LayoutCopyright/HBoxContainer/Copyright.text = R.getString("copyright")
	
	$Ui/LayoutBoutons/HBoxContainer/VBoxContainer/BtnJouer.text = R.getString("btnJouer")
	$Ui/LayoutBoutons/HBoxContainer/VBoxContainer/BtnOptions.text = R.getString("btnOptions")
	$Ui/LayoutBoutons/HBoxContainer/VBoxContainer/BtnQuit.text = R.getString("btnQuitter")
	
	$Ui/LayoutPanelJouer.visible = false

#==================
#	Sigaux

func _on_BtnJouer_pressed():
	$Ui/LayoutPanelJouer.visible = true
	self.panelJouer.visible = true
	$Ui/LayoutBoutons/HBoxContainer/VBoxContainer/BtnJouer.disabled = true
	yield(self.panelJouer, "visibility_changed")
	$Ui/LayoutBoutons/HBoxContainer/VBoxContainer/BtnJouer.disabled = false
	$Ui/LayoutPanelJouer.visible = false


func _on_BtnOptions_pressed():
	Globals.optionAffiche()


func _on_BtnQuit_pressed():
	Globals.quitter()
