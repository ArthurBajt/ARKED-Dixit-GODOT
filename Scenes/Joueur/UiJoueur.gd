extends Control

onready var labelNom = $VBoxContainer/LabelNom
onready  var labelPoints = $VBoxContainer/LabelPoints
onready var labelConteur = $VBoxContainer/LabelConteur
onready var vboxConteur = $VBoxContainer/VBoxContainerConteur
onready var hSperatorNoConteur = null


func _ready():
	labelNom.text = R.getString("labelNom") % str(Network.id)
	labelPoints.text = R.getString("labelPoints") % str( Network.data.points )
	labelConteur.text = R.getString("labelConteur")
	vboxConteur

func afficheUiConteur(isConteur):
	vboxConteur.visible = isConteur
