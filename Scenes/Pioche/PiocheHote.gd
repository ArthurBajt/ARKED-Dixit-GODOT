extends "res://Scenes/Pioche/Pioche.gd"


var deck: Array



func _ready():
	_initDeck()



func piocher(joueur: Joueur):
	""" Donne une carte a un joueur """
	if deck.size() == 0:
		_initDeck()
	
	var carte = deck.pop_front()
	var type = Globals.typesCartes.NORMALE
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var number
	number = rng.randf_range(0,40) # 40
	if(number<1):
		type = Globals.typesCartes.DOUBLE
	else:
		number = rng.randf_range(0,36) # 36
		if(number<1):
			type = Globals.typesCartes.PIQUES
	
	Network.joueurPioche(joueur.id, carte, type)


func _initDeck():
	deck = R.getDeck()
	randomize()
	deck.shuffle()


