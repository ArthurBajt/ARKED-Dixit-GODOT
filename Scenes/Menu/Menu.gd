extends Node


onready var buttonCreer = $Ui/ButtonCreer
onready var buttonRejoindre = $Ui/ButtonRejoindre

func _ready():
	buttonCreer.text = R.getString("buttonCreer")
	buttonRejoindre.text = R.getString("buttonRejoindre")


func _on_ButtonCreer_pressed():
	Network.creerServeur()
	get_tree().change_scene("res://Scenes/Lobby/Lobby.tscn")


func _on_ButtonRejoindre_pressed():
	Network.rejoindreServeur()
	get_tree().change_scene("res://Scenes/Lobby/Lobby.tscn")
