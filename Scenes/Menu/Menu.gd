extends Node



func _on_ButtonCreer_pressed():
	Network.creerServeur()
	get_tree().change_scene("res://Scenes/Lobby/Lobby.tscn")


func _on_ButtonRejoindre_pressed():
	Network.rejoindreServeur()
	get_tree().change_scene("res://Scenes/Lobby/Lobby.tscn")
