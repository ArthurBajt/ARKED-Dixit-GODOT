extends Node


var isDebug: bool = true setget setDebug

enum EtatJoueur {
				SELECTION_CARTE_THEME, 		# Conteur			0
				CHOIX_THEME,				# Conteur			1
				ATTENTE_CHOIX_THEME,		# Joueur			2
				SELECTION_CARTE,			# Joueur			3
				ATTENTE_SELECTIONS,			# Conteur & Joueur	4
				VOTE,						# Joueur			5
				ATTENTE_VOTES,				# Conteur & Joueur	6
				VOIR_RESULTAT,				# Conteur & Joueur	7
				ATTENTE_PROCHAINE_MANCHE	# Conteur & Joueur	8
				}

enum couleurs {
	ROUGE,
	ORANGE,
	ROSE,
	VIOLET,
	BLEU,
	CYAN,
	VERT,
	JAUNE
}

const couleursValeurs: Dictionary = {
	couleurs.ROUGE: Color("#ff0000"),
	couleurs.ORANGE: Color("#ff9900"),
	couleurs.ROSE: Color("#ff66cc"),
	couleurs.VIOLET: Color("#9933ff"),
	couleurs.BLEU: Color("#0066ff"),
	couleurs.CYAN: Color("#00ffcc"),
	couleurs.VERT: Color("#66ff33"),
	couleurs.JAUNE: Color("#ffff00"),
}


func _ready():
	self.options = self.NODE_OPTIONS.instance()
	get_parent().call_deferred("add_child", self.options)
	
	self.fov = self.FOV_DEFAUT


func setDebug(value: bool):
	isDebug = value


func quitter():
	Transition.transitionVers("res://Scenes/Intro&Outro/Outro.tscn")


# ==================
#	Options
const NODE_OPTIONS = preload("res://Scenes/Options/Options.tscn")
var options: Options

func optionAffiche():
	""" Si on fait une Ui pour des options """
	self.options.affiche()
	pass


func optionCache():
	""" Si on fait une Ui pour des options, on la cache. """
	self.options.cache()
	pass

#======================
#	Fov dynamique pour diff ecrand

signal fovChanged( val )
const FOV_DEFAUT: float = 60.0
const FOV_MIN: float = 25.0
const FOV_MAX: float = 120.0
var fov: float setget setFov


func setFov( val: float ):
	var newFov = max( self.FOV_MIN, min(val, self.FOV_MAX) )
	if newFov != fov:
		fov = newFov
		emit_signal("fovChanged", fov)

#======================
#	Message d'erreurs

onready var ERR_MESSAGE_NODE = preload("res://Scenes/ErrMessage/ErrMessage.tscn")

func afficheErreur(erreur: String):
	var errNode = self.ERR_MESSAGE_NODE.instance()
	get_parent().call_deferred("add_child", errNode)
	yield(get_tree(), "idle_frame")
	errNode.setMessage(erreur)
	get_parent().move_child( errNode, get_parent().get_child_count() )
