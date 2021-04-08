extends Node


onready var buttonCreer = $Ui/VBoxContainer/HBoxContainer2/ButtonCreer
onready var buttonRejoindre = $Ui/VBoxContainer/HBoxContainer2/ButtonRejoindre

var player_name = ""

func _ready():
	buttonCreer.text = R.getString("buttonCreer")
	buttonRejoindre.text = R.getString("buttonRejoindre")


func _on_ButtonCreer_pressed():
	if(player_name != ""):
		Network.creerServeur(player_name)
		get_tree().change_scene("res://Scenes/Lobby/Lobby.tscn")


func _on_ButtonRejoindre_pressed():
	if(player_name != ""):
		Network.rejoindreServeur(player_name)
		get_tree().change_scene("res://Scenes/Lobby/Lobby.tscn")

func _on_inputPseudo_text_changed(new_text):
	player_name = new_text
