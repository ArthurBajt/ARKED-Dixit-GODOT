extends Control

onready var labelNom = $LabelNom
onready  var labelPoints = $LabelPoints
onready var labelConteur = $LabelConteur


func _ready():
	labelNom.text = R.getString("labelNom") % str(Network.id)
	labelPoints.text = R.getString("labelPoints") % str( Network.data.points )
	labelConteur.text = R.getString("labelConteur")
