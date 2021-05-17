#	La classe: R 	(-> pour Ressources)
#	est la classe permettant d'acceder aux ressources du jeu:
#	- getString(clef) -> d'acceder aux textes contenus dans 'Strings.js'
#										> > > ATTENTION ! < < <
#								le contenu de 'Strings.js' doit être de la forme:
#									{
#										uneClef: 'la valeur de cette clef.' ,
#										uneAutreClef: 'Une autre valeur attachée !'
#									}
extends Node


var _strings: Dictionary = { }
const PATH_TO_STRINGS: String= "res://Assets/Values/Strings.json"

var _cartes: Dictionary = { }
const PATH_TO_CARDS: String= "res://Assets/Sprites/Cartes/"

const PATH_TO_CARD_DEFAULT: String = "res://Scenes/Carte/Carte_defaut.jpeg"
var carteTextureDefaut: ImageTexture



func _ready():
	_loadStrings()
	_loadCartes()
	_loadTextureCarteDefaut()



# ============================
#	R.strings
func _loadStrings():
	""" Charge tout les txt contenu dans le fichier contenant les ressources de txt"""
	var file = File.new()
	file.open(PATH_TO_STRINGS, File.READ)
	var nvStrings: Dictionary = parse_json(file.get_as_text())
	assert( typeof(nvStrings) == TYPE_DICTIONARY, "err - _loadStrings()")
	_strings = nvStrings.duplicate()
	file.close()


func getString(key: String)-> String:
	""" retourne le text de la clef contenus dans le fichier de ressources txt."""
	if not key in _strings:
		push_warning("Cette clef n'est pas dans les ressources de txt.")
		return ""
	return str(_strings.get(key))


# ============================
#	R.cartes

func _loadCartes():
	var index: int = 0
	for carteImg in self.listeCarte:
		carteImg.lock()
		var texture: ImageTexture = ImageTexture.new()
		texture.create_from_image(carteImg)
		self._cartes["carte_"+str(index)] = texture
		index += 1


func _loadTextureCarteDefaut():
	""" Charge la texture par defaut des cartes """
	var streamTexture = load(PATH_TO_CARD_DEFAULT)
	var image = streamTexture.get_data()
	var imageTexture = ImageTexture.new()
	imageTexture.create_from_image(image)
	carteTextureDefaut = imageTexture
	


func getCarte(key: String) -> ImageTexture:
	""" Renvoie la texture associée à une carte. """
	if not key in _cartes:
		push_warning("Cette clef n'est pas le nom d'une carte")
		return ImageTexture.new()
	return _cartes[key]


func getCarteDefaut() -> ImageTexture:
	""" Renvoie la texture par defaut pour les carte non-visible.  """
	return carteTextureDefaut


func getDeck()->Array:
	""" Renvoie un Array de String avec le nom des cartes, afin de representer une pioche / un deck. """
	var res = []
	for c in _cartes:
		res.append(c)
	return res


#========================

onready var listeCarte: Array = [
	load("res://Assets/Sprites/Cartes/Carte (1).jpeg"), load("res://Assets/Sprites/Cartes/Carte (2).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (3).jpeg"), load("res://Assets/Sprites/Cartes/Carte (4).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (5).jpeg"), load("res://Assets/Sprites/Cartes/Carte (6).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (7).jpeg"), load("res://Assets/Sprites/Cartes/Carte (8).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (9).jpeg"), load("res://Assets/Sprites/Cartes/Carte (10).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (11).jpeg"), load("res://Assets/Sprites/Cartes/Carte (12).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (13).jpeg"), load("res://Assets/Sprites/Cartes/Carte (14).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (15).jpeg"), load("res://Assets/Sprites/Cartes/Carte (16).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (17).jpeg"), load("res://Assets/Sprites/Cartes/Carte (18).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (19).jpeg"), load("res://Assets/Sprites/Cartes/Carte (20).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (21).jpeg"), load("res://Assets/Sprites/Cartes/Carte (22).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (23).jpeg"), load("res://Assets/Sprites/Cartes/Carte (24).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (25).jpeg"), load("res://Assets/Sprites/Cartes/Carte (26).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (27).jpeg"), load("res://Assets/Sprites/Cartes/Carte (28).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (29).jpeg"), load("res://Assets/Sprites/Cartes/Carte (30).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (31).jpeg"), load("res://Assets/Sprites/Cartes/Carte (32).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (33).jpeg"), load("res://Assets/Sprites/Cartes/Carte (34).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (35).jpeg"), load("res://Assets/Sprites/Cartes/Carte (36).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (37).jpeg"), load("res://Assets/Sprites/Cartes/Carte (38).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (39).jpeg"), load("res://Assets/Sprites/Cartes/Carte (40).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (41).jpeg"), load("res://Assets/Sprites/Cartes/Carte (42).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (43).jpeg"), load("res://Assets/Sprites/Cartes/Carte (44).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (45).jpeg"), load("res://Assets/Sprites/Cartes/Carte (46).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (47).jpeg"), load("res://Assets/Sprites/Cartes/Carte (48).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (49).jpeg"), load("res://Assets/Sprites/Cartes/Carte (50).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (51).jpeg"), load("res://Assets/Sprites/Cartes/Carte (52).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (53).jpeg"), load("res://Assets/Sprites/Cartes/Carte (54).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (55).jpeg"), load("res://Assets/Sprites/Cartes/Carte (56).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (57).jpeg"), load("res://Assets/Sprites/Cartes/Carte (58).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (59).jpeg"), load("res://Assets/Sprites/Cartes/Carte (60).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (61).jpeg"), load("res://Assets/Sprites/Cartes/Carte (62).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (63).jpeg"), load("res://Assets/Sprites/Cartes/Carte (64).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (65).jpeg"), load("res://Assets/Sprites/Cartes/Carte (66).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (67).jpeg"), load("res://Assets/Sprites/Cartes/Carte (68).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (69).jpeg"), load("res://Assets/Sprites/Cartes/Carte (70).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (71).jpeg"), load("res://Assets/Sprites/Cartes/Carte (72).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (73).jpeg"), load("res://Assets/Sprites/Cartes/Carte (74).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (75).jpeg"), load("res://Assets/Sprites/Cartes/Carte (76).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (77).jpeg"), load("res://Assets/Sprites/Cartes/Carte (78).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (79).jpeg"), load("res://Assets/Sprites/Cartes/Carte (80).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (81).jpeg"), load("res://Assets/Sprites/Cartes/Carte (82).jpeg"),
	load("res://Assets/Sprites/Cartes/Carte (83).jpeg"), load("res://Assets/Sprites/Cartes/Carte (84).jpeg")
]
