extends Node


# Declare member variables here. Examples:
var nom = ""
var points = 0
var description = ""

func getNom():
	return self.nom

func getPoints():
	return self.points

func getDescription():
	return self.description

func setNom(name):
	self.nom = name

func setPoints(poin):
	self.points = poin

func setDescription(descri):
	self.description = descri


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
