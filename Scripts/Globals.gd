extends Node


var isDebug: bool = true setget setDebug

var isMobile:bool = false

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

func setDebug(value: bool):
	isDebug = value


func quitter():
	get_tree().quit()


# ==================
#	Options

func optionAffiche():
	""" Si on fait une Ui pour des options """
	print("affiche options")
	pass


func optionCache():
	""" Si on fait une Ui pour des options, on la cache. """
	print("cache options")
	pass
