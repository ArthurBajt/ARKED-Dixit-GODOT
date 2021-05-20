extends Control

var id
var pseudo
var points

func _ready():
	pseudo = "N/A"
	points = 0

func _process(delta):
	var pseudo = Network.utilisateurs[id].nom
	points = Network.utilisateurs[id].points
	$HBoxContainer/Label.text = pseudo
	$HBoxContainer/Label2.text = str(points)

