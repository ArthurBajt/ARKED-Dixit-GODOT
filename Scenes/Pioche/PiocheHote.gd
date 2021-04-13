extends "res://Scenes/Pioche/Pioche.gd"


var deck: Array



func _ready():
	_initDeck()



func piocher(joueur: Joueur):
	""" Donne une carte a un joueur """
	if deck.size() == 0:
		_initDeck()
	
	var carte = deck.pop_front()
	Network.joueurPioche(joueur.id, carte)


func _initDeck():
	deck = R.getDeck()
	randomize()
	deck.shuffle()

	print(deck)
