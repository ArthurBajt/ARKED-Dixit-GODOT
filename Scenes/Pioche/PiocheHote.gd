extends "res://Scenes/Pioche/Pioche.gd"


var deck: Array



func _ready():
	_initDeck()



func piocher(joueur: Joueur):
	""" Donne une carte a un joueur """
	if deck.size() == 0:
		_initDeck()
	
	var carte = deck.pop_front()
	var coef = 1
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var number = rng.randf_range(0,20)
	if(number<=1):
		coef = 2 
	
	Network.joueurPioche(joueur.id, carte,coef)


func _initDeck():
	deck = R.getDeck()
	randomize()
	deck.shuffle()


