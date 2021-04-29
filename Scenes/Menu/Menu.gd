extends Node

onready var lineEditPseudo = $Ui/VBoxContainer/HBoxContainer/inputPseudo
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
	else:
		refusPseudo()


func _on_ButtonRejoindre_pressed():
	if(player_name != ""):
		Network.rejoindreServeur(player_name)
		get_tree().change_scene("res://Scenes/Lobby/Lobby.tscn")
	else:
		refusPseudo()

func _on_inputPseudo_text_changed(new_text):
	player_name = new_text


func refusPseudo():
	# Animation d'erreur
	lineEditPseudo.modulate = Color("f21b1b")
	for _i in range(0,2):
		var repetition = 3
		for _j in range(0,repetition):
			lineEditPseudo.rect_position.x += 1
			yield(get_tree().create_timer(0.01), "timeout")
		for _j in range(0,2*repetition):
			lineEditPseudo.rect_position.x -= 1
			yield(get_tree().create_timer(0.01), "timeout")
		for _j in range(0,repetition):
			lineEditPseudo.rect_position.x += 1
			yield(get_tree().create_timer(0.01), "timeout")
	lineEditPseudo.modulate = Color("ffffff")
