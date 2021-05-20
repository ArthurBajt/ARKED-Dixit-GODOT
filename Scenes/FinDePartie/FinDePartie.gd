extends Control


onready var buttonRejouer = $VBoxContainer/ButtonRejouer
onready var buttonQuitter = $VBoxContainer/ButtonQuitter


# Called when the node enters the scene tree for the first time.
func _ready():
	Network.connect("versLobby", self, "retourLobby")
	if !Network.data.estConteur:
		buttonRejouer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonRejouer_pressed():
	Network.rejouer()


func _on_ButtonQuitter_pressed():
	if Network.id !=1:
		Network.peerClient.close_connection()
	else:
		Network.peerServ.close_connection()
		
	Network.data={}
	Network.data=Network.dataStruct.duplicate()
	Network.utilisateurs={}
	
	Network.retour_menu()

func retourLobby():
	Transition.transitionVers("res://Scenes/Lobby/Lobby.tscn")
	
