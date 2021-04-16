extends Node


var isDebug: bool = true setget setDebug

enum EtatJoueur {
				SELECTION_CARTE_THEME, 		# Conteur			0
				CHOIX_THEME,				# Conteur			1
				ATTENTE_CHOIX_THEME,		# Joueur			2
				ATTENTE_SELECTIONS,			# Conteur & Joueur	3
				SELECTION_CARTE,			# Joueur			4
				ATTENTE_VOTES,				# Conteur & Joueur	5
				VOTE,						# Joueur			6
				VOIR_RESULTAT,				# Conteur & Joueur	7
				ATTENTE_PROCHAINE_MANCHE	# Conteur & Joueur	8
				}

func setDebug(value: bool):
	isDebug = value
