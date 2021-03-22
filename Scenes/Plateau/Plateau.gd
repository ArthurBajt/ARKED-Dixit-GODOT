extends Spatial


var joueurs: Array = []
var estHote: bool


var pioche


func init(joueursDeLaPartie: Array):
	joueurs = joueursDeLaPartie
	estHote = Network.id == 1
