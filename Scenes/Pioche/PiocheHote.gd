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
	number = rng.randf_range(0,99) # 1/100 -> 2% D | 1.5% -> P | 1% -> B | 0.7% -> M
	if(number<2):
		type = Globals.typesCartes.DOUBLE
	elif(number<3.5):
		type = Globals.typesCartes.PIQUES
	elif(number<4.5):
		type = Globals.typesCartes.BOURRE
	elif(number<5.2): 
		type = Globals.typesCartes.MYSTERE
	
	Network.joueurPioche(joueur.id, carte, type)


func _initDeck():
	deck = R.getDeck()
	randomize()
	deck.shuffle()


