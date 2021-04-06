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
	""" Initialise le dict des carte
	en fonction de ce qui est contenus dans :  [PATH_TO_CARDS] """
	
	var reg:RegEx = RegEx.new()
	reg.compile('.jpeg$')
	
	var dir = Directory.new()
	assert(dir.open(PATH_TO_CARDS) == OK , "err - _loadCartes()")
	
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if not  dir.current_is_dir():
			if reg.search(file):
				# pour puvoir exporter le jeu, c'est mieux d'utiliser un stream
				var streamTexture = load(PATH_TO_CARDS + file)
				var image = streamTexture.get_data()
				var imageTexture = ImageTexture.new()
				imageTexture.create_from_image(image)
				_cartes[file] = imageTexture
		
		file = dir.get_next()


func _loadTextureCarteDefaut():
	""" Charge la texture par defaut des cartes """
	var streamTexture = load(PATH_TO_CARD_DEFAULT)
	var image = streamTexture.get_data()
	var imageTexture = ImageTexture.new()
	imageTexture.create_from_image(image)
	carteTextureDefaut = imageTexture
	


func getCarte(key: String) -> ImageTexture:
	""" Renvoie la texture associer a une carte. """
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
