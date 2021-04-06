extends Node

onready var buttonPret = $Control/HBoxContainer/VBoxContainer/ButtonPret
onready var buttonLancer = $Control/HBoxContainer/VBoxContainer/ButtonLancer


func _ready():
	Network.connect("partieLancee", self, "_versPartie")
	buttonLancer.visible = Network.id == 1

func _on_ButtonPret_pressed():
	Network.lobby_setStatu(!Network.data.estPret)


func _on_ButtonLancer_pressed():
	Network.lobby_lancerPartie()


func _versPartie():
	get_tree().change_scene("res://Scenes/Partie/Partie.tscn")
