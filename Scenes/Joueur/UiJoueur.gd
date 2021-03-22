extends Control

onready var labelNom = $LabelNom



func _ready():
	labelNom.text = "Vous etre le joueur: " + str(Network.id)
