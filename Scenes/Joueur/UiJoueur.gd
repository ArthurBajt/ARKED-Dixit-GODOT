extends Control

onready var labelNom = $VBoxContainer/LabelNom
onready var labelPoints = $VBoxContainer/LabelPoints
onready var labelConteur = $VBoxContainer/LabelConteur

func _ready():
	labelNom.text = R.getString("labelNom") % str(Network.id)
	labelPoints.text = R.getString("labelPoints") % str( Network.data.points )
	labelConteur.text = R.getString("labelConteur")
	

func changeTheme(theme, estConteur=true, nomConteur=""):
	if(estConteur):
		labelConteur.text = "Vous avez choisi : %s" % theme
	else:
		labelConteur.text = "%s a choisi : %s" % [nomConteur,theme]
