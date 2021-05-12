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

# ==================
# Silent wolf S/o leaderboard

func setDebug(value: bool):
	isDebug = value
	SilentWolf.configure({
		"api_key": "FmKF4gtm0Z2RbUAEU62kZ2OZoYLj4PyOl5kC5Mcf7w4Z7RPwnxU0suZmmKhc45yJ2Zwgod",
	"game_id": "Arked Dixit",
	"game_version": "0.0.0"
	})
	SilentWolf.configure_scores({
	"open_scene_on_close": "res://Scenes/Splash.tscn"
	})






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
