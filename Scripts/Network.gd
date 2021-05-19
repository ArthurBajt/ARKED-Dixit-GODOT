extends Node

const DEFAUT_IP: String = '127.0.0.1'
const DEFAUT_PORT: int = 31400
const MAX_UTILISATEURS: int = 99


var id: int = 0
var nom = ""
var erreur_connexion
var tabCouleur=[Color.rebeccapurple,Color.orange,Color.maroon,Color.cadetblue,Color.red,Color.green]


func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_lobby_se_declarer")
	get_tree().connect("connection_failed", self, "retour_menu")
	get_tree().connect("server_disconnected", self, "deconnexion_server")
	get_tree().connect("network_peer_disconnected", self, "deconnexion_client")


func creerServeur(player_name, ip):
	""" Creer un serveur """
#	dataStruct.nom = player_name

	self.nom = player_name
	var peer = NetworkedMultiplayerENet.new()
	peer.set_bind_ip(ip)
	peer.create_server(DEFAUT_PORT, MAX_UTILISATEURS)
	get_tree().set_network_peer(peer)
	_lobby_se_declarer()
	
func rejoindreServeur(player_name, ipHote):
	""" Fait rejoindre un serveur à un utilisateur"""
#	dataStruct.nom = player_name
	self.nom = player_name
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ipHote, DEFAUT_PORT)
	get_tree().set_network_peer(peer)


# =================================================
# Lobby

var utilisateurs: Dictionary
var data: Dictionary
const dataStruct = {nom = "",
					estPret = false,
					estDansPartie = false,
					main = [],
					cartesPlateau = {},
					carteVotee = null,
					points = 0,
					estConteur = false,
					#couleur = Globals.COULEUR_DEFAUT,
					objectif = 30
					}



signal nvUtilisateur(idUtilisateur)
signal nvStatuUtilisateur(idUtilisateur, statu)
signal partieLancee



func _lobby_se_declarer():
	""" Quand un joueur se connecte au serveur
	Il recupère son ID propre.
	Et déclare sa présence au serveur. """
	
	
	if get_tree().is_network_server():
		id = 1
	
	else:
		id = get_tree().get_network_unique_id()
	
	self.data = dataStruct.duplicate()
	self.data.nom = self.nom
	
	utilisateurs[id] = dataStruct.duplicate()
	utilisateurs[id].nom = self.nom
	
	if id > 1 :
		rpc_id(1, "_lobby_declareUtilisateur", id, self.data)

func retour_menu():
	Transition.transitionVers("res://Scenes/MenuPrincipal/MenuPrincipal.tscn")

signal decoJoueur(id)
remotesync func deconnexion_client(id):
	
	utilisateurs.erase(id)
	emit_signal("decoJoueur", id)



remotesync func deconnexion_server():
	if self.id!=1:
		erreur_connexion = R.getString("networkErrHoteQuitte")


	
	get_tree().set_network_peer(null)

	self.data={}
	self.data=self.dataStruct.duplicate()
	self.utilisateurs={}
	
	retour_menu()

#func retourMenuClient(id):
#
#	utilisateurs.erase(id)
#	emit_signal("decoJoueur", id)
#	retour_menu()
#
#func _deconnexion_server():
#	erreur_connexion = R.getString("networkErrHoteQuitte")
#	print(erreur_connexion)
#
#
#	get_tree().set_network_peer(null)
#
#	self.data={}
#	self.data=self.dataStruct.duplicate()
#	self.utilisateurs={}
#
#	retour_menu()

remote func _lobby_declareUtilisateur(idUtilisateur: int, curentData:Dictionary ):
	""" Quand un utilisateur se déclare,
	le serveur signal a tt les utilisateur déjà présents
	qu'un nv Utilisateur s'est connecté."""
	
#	rpc("_lobby_ajouteUtilisateur", idUtilisateur, dataStruct.duplicate())
	rpc("_lobby_ajouteUtilisateur", idUtilisateur, curentData.duplicate() )
	for usId in utilisateurs:
		rpc_id(idUtilisateur,"_lobby_ajouteUtilisateur", usId, utilisateurs[usId])


remotesync func _lobby_ajouteUtilisateur(idUtilisateur: int, curentData: Dictionary = {}):
	""" Le serveur a declarer l'arrivee d'un nv Utilisateur
	ou
	Nous somme un client arrivant sur le serveur
	
	On met a jour les Utilisateur deja presents et leurs données"""
	utilisateurs[idUtilisateur] = curentData.duplicate()
	
	emit_signal("nvUtilisateur", idUtilisateur)


func lobby_setStatu(statu: bool):
	""" Permet a un client de changer son statu, si il est pret ou nn."""
	self.data.estPret = statu
	rpc("_lobby_declareStatu", id, statu)



remotesync func _lobby_declareStatu(idUtilisateur: int, statu: bool):
	""" Permet au serveur de mettre a jour le statu d'un utilisateur pour tt les autres."""
	rpc("_lobby_appliquerStatu", idUtilisateur, statu)


remotesync func _lobby_appliquerStatu(idUtilisateur: int, statu: bool):
	""" change le statu d'un joueur"""
#	if (not "estPret" in utilisateurs[idUtilisateur]) or (utilisateurs[idUtilisateur].estPret != statu):
#		emit_signal("nvStatuUtilisateur", idUtilisateur, statu)
	
	utilisateurs[idUtilisateur].estPret = statu
	if id == idUtilisateur:
		data.estPret = statu
	emit_signal("nvStatuUtilisateur", idUtilisateur, statu)


func lobby_lancerPartie():
	""" Permet a l'hote de la partie de démarer le jeu pour tt les utilisateurs"""
	if id == 1 and _peutLancerPartie():
		rpc("_lobby_lancePartie")


remotesync func _lobby_lancePartie():
	""" Signal a tt les utilisateurs du lobby que la partie commence."""
	emit_signal("partieLancee")

func assigneCouleur():


	var tabTemp=[]
	for usId in utilisateurs:
		tabTemp.append(usId)
	
	tabTemp.sort()
	for usId in tabTemp:
		var couleurTemp=tabCouleur.pop_front()
		utilisateurs[usId].couleur=couleurTemp


func _peutLancerPartie()->bool:
	""" True si on peut lancer la partie """
	for usId in utilisateurs:
		if not "estPret" in utilisateurs[usId]:
			return false
		
		if not utilisateurs[usId].estPret:
			return false
	
	return true


# =================================================
# Partie

#	Quand tt les joueurs on chargé la scene de la partie
signal JoueursDansPartie

func partie_setChargee():
	"""Un est appelée quand un joueur a charger la scenen de dela partie."""
	if id!=1:
		rpc_id(1, "_partie_declareChargee", id)
	else:
		_partie_declareChargee(1)


remotesync func _partie_declareChargee(idJoeuur: int):
	""" """

	rpc("_partie_appliqueChargee", idJoeuur)



remotesync func _partie_appliqueChargee(idJoueur: int):
	if idJoueur == id:
		data.estDansPartie = true
	utilisateurs[idJoueur].estDansPartie = true
	
	if id == 1 and _sontJoueursDansPartie():

		
		emit_signal("JoueursDansPartie")



func _sontJoueursDansPartie()->bool:

	for usId in utilisateurs:

		if not utilisateurs[usId].estDansPartie:
			return false
	return true

func voteCarte(carte, idJoueur):
	rpc("joueurVoteCarte", carte.nom, idJoueur)

signal carteVotee(nomCarte, idJoueur)

remotesync func joueurVoteCarte(nomCarte,idJoueur):
	if(idJoueur == self.id):
		self.data.carteVotee = nomCarte
	
	self.utilisateurs[idJoueur].carteVotee = nomCarte

	self.utilisateurs[idJoueur].etat = Globals.EtatJoueur.ATTENTE_VOTES
	emit_signal("carteVotee", nomCarte, idJoueur)
# =================================================
# Cartes

signal joueurApiocherCarte(id, carte)

func joueurPioche(idJoueur: int, carte: String):
	rpc("_joueurPiocheCarte", idJoueur, carte)



remotesync func _joueurPiocheCarte(idJoueur: int, carte: String):
	if idJoueur == id:
		self.data.main = self.data.main + [carte]
	utilisateurs[idJoueur].main = utilisateurs[idJoueur].main + [carte]
	emit_signal("joueurApiocherCarte", idJoueur, carte)

# =================================================
# Plateau

signal JoueurPoseCarte(idJoueur, nomCarte)
signal APoseCarte()

func posercarte(idJoueur: int, carte: String):
	rpc("appliquePoseCarte", idJoueur, carte)
	
remotesync func appliquePoseCarte(idJoueur: int, carte: String):
	self.data.cartesPlateau[idJoueur] = carte
	if idJoueur == self.id:
		self.data.main.erase(carte)
	
	for jId in self.utilisateurs:
		self.utilisateurs[jId].cartesPlateau[idJoueur] = carte
	self.utilisateurs[idJoueur].main.erase(carte)
	
	if(!self.utilisateurs[idJoueur].estConteur):
		self.utilisateurs[idJoueur].etat = Globals.EtatJoueur.ATTENTE_SELECTIONS
	else:
		self.utilisateurs[idJoueur].etat = Globals.EtatJoueur.CHOIX_THEME
	self.verifEtat(Globals.EtatJoueur.ATTENTE_SELECTIONS)
		
	
	emit_signal("JoueurPoseCarte", idJoueur, carte)
	emit_signal("APoseCarte", idJoueur)
	
signal ChangementConteur

func changeConteur(idJoueur):
	rpc("declareChangementConteur", idJoueur)
	
remotesync func declareChangementConteur(idJoueur):
	self.data.estConteur = (idJoueur == self.id)
	for usId in self.utilisateurs:
		if usId == idJoueur:
			self.utilisateurs[usId].etat = Globals.EtatJoueur.SELECTION_CARTE_THEME
		else:
			self.utilisateurs[usId].etat = Globals.EtatJoueur.ATTENTE_CHOIX_THEME
		self.utilisateurs[usId].estConteur = usId == idJoueur
	emit_signal("ChangementConteur", idJoueur)
			


# =================================================
# Chat
signal updateChat
func envoieMessage(msg):
	rpc("messageRecu", self.data.nom , msg)
	
remotesync func messageRecu(pseudo, msg):
	emit_signal("updateChat", pseudo, msg)

# =================================================
# Theme
signal updateTheme
func defineTheme(theme):
	rpc("changeTheme", theme, self.data.nom)
	
remotesync func changeTheme(theme, nomConteur):
	for usId in self.utilisateurs:
		if(self.utilisateurs[usId].estConteur):
			self.utilisateurs[usId].etat = Globals.EtatJoueur.ATTENTE_SELECTIONS
		else:
			self.utilisateurs[usId].etat = Globals.EtatJoueur.SELECTION_CARTE
		
	emit_signal("updateTheme", theme, nomConteur)

func verifEtat(etat):
	rpc("verifEtats",etat, Network.id)

signal vote
signal voirRes
signal prochaineManche
signal finDePartie
remotesync func verifEtats(etat, idClient):
		
	var nbJoueur = utilisateurs.size()
	var compteur = 0
	for usId in self.utilisateurs:
		if (self.utilisateurs[usId].etat==etat):
		
			compteur+=1
			
	
	if (compteur == nbJoueur):
		if(etat==Globals.EtatJoueur.ATTENTE_SELECTIONS):
			for user in self.utilisateurs:
				if self.utilisateurs[user].estConteur:
					self.utilisateurs[user].etat=Globals.EtatJoueur.ATTENTE_VOTES
				else:
					self.utilisateurs[user].etat=Globals.EtatJoueur.VOTE
				emit_signal("vote")

					
				print("V1 Etat de %s [%s]: %s" % [utilisateurs[user].nom, user,utilisateurs[user].etat])
		
		elif(etat==Globals.EtatJoueur.ATTENTE_VOTES):
			for user in self.utilisateurs:
				self.utilisateurs[user].etat = Globals.EtatJoueur.VOIR_RESULTAT
			emit_signal("voirRes")
			if(Network.id == idClient):
				self.afficheVoteurs()
				self.calculPoints()
		
		elif(etat==Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE):
			self.data.cartesPlateau = {}
			for user in self.utilisateurs:
				self.utilisateurs[user].cartesPlateau = {}
				self.utilisateurs[user].carteVotee = null
				self.utilisateurs[user].etat = Globals.EtatJoueur.ATTENTE_CHOIX_THEME
			
			var aFini = false
			for user in self.utilisateurs:
				aFini = aFini or self.utilisateurs[user].points>=30
			if aFini:
				emit_signal("finDePartie")
			else:
				emit_signal("prochaineManche")

#	for usId in self.utilisateurs:
#		print("V2 Etat de %s [%s]: %s" % [utilisateurs[usId].nom, usId,utilisateurs[usId].etat])


# =================================================
# Couleur Joueur

func changeObjectif(nbPoint):
	rpc("objectifDeclare",nbPoint)

remotesync func objectifDeclare(nbPoint):
	self.data.objectif = nbPoint
	for idJoueur in utilisateurs:
		self.utilisateurs[idJoueur].objectif = nbPoint


signal joueurChangeCouleur(id, coul)
func setCouleurJoueur(idJoueur: int, coul: Color):
	rpc("couleurDeclare", id, coul)


remotesync func couleurDeclare(idJoueur: int, coul: Color):
	if self.id == idJoueur:
		self.data.couleur = coul
	self.utilisateurs[idJoueur].couleur = coul
	emit_signal("joueurChangeCouleur", idJoueur, coul)


func getCouleurUtilisee():
	""" Renvoie les couleurs déjà utilisées par les utilisateurs"""
	var res: Array = []
	for usId in self.utilisateurs:
		if usId != self.id:
			var coul = self.utilisateurs[usId].couleur
			if coul in Globals.couleursValeurs.values() and not coul in res:
				res.append(coul) 
	return res

func getCouleursPossibles()-> Array:
	var res: Array = Globals.couleursValeurs.values().duplicate()
	for c in self.getCouleurUtilisee():
		res.erase(c)
	return res

func couleurJoueur(idJoueur):
	for usId in utilisateurs:
		if usId == idJoueur:
			return utilisateurs[usId].couleur

func calculPoints():
	var votes = {}
	var idConteur = 0
	for user in self.utilisateurs:
		if(!self.utilisateurs[user].estConteur):
			votes[user] = self.utilisateurs[user].carteVotee
	for user in self.utilisateurs:
		if(self.utilisateurs[user].estConteur):
			idConteur = user
	rpc("calculDesPoints", votes, self.utilisateurs[Network.id].cartesPlateau, idConteur)


signal pointsCumules(idJoueur, points, cartePosee, carteVotee)
remotesync func calculDesPoints(votes, cartesPosees : Dictionary, idConteur):
	var cartePosed = cartesPosees.get(idConteur)
	var compteurOnCarteConteur = 0
	for idJ in votes:
		if(votes.get(idJ) == cartePosed):
			compteurOnCarteConteur+=1
	
	if(compteurOnCarteConteur == 0 or compteurOnCarteConteur == self.utilisateurs.size()-1):
		for user in self.utilisateurs:
			if(user == idConteur):
				emit_signal("pointsCumules",user,0,cartesPosees.get(user),null)
			else:
				emit_signal("pointsCumules",user,2,cartesPosees.get(user),votes.get(user))
	else:
		for user in self.utilisateurs:
			if(user == idConteur):
				emit_signal("pointsCumules",user,3,cartesPosees.get(user),null)
			else:
				cartePosed = cartesPosees.get(user)
				var compteur = 0
				for idJ in votes:
					if(votes.get(idJ) == cartePosed):
						compteur+=1
				emit_signal("pointsCumules",user,compteur,cartesPosees.get(user),votes.get(user))
				
				if(votes.get(user) == cartesPosees.get(idConteur)):
					emit_signal("pointsCumules",user,3,cartesPosees.get(user),votes.get(user))

func setPointsJoueur(jId, points):
	rpc("setPointsJoueurRPC",jId, points)
	
remotesync func setPointsJoueurRPC(jId, points):
	if(self.id == jId):
		self.data.points = points
	self.utilisateurs[jId].points = points
	

func afficheVoteurs():
	var nomCartes = []
	for user in self.utilisateurs:
		if(!self.utilisateurs[user].estConteur):
			if(not(self.utilisateurs[user].carteVotee in nomCartes)):
				nomCartes.append(self.utilisateurs[user].carteVotee)
	print(nomCartes)
	for c in nomCartes:
		rpc("getVoteurs",c)

signal giveVoteurs(nomCarte, joueurs)
remotesync func getVoteurs(nomCarte):
	var joueurs = []
	for user in self.utilisateurs:
		if(self.utilisateurs[user].carteVotee == nomCarte):
			joueurs += [user]
	emit_signal("giveVoteurs",nomCarte,joueurs)
	

#=================================
# 	leaderboard
func getNom():
	var tab = []
	for user in self.utilisateurs:
		tab.append(self.utilisateurs[user])
	print(tab[0])
	return tab[0].nom

func getScore():
	var tab = []
	for user in self.utilisateurs:
		tab.append(self.utilisateurs[user])
	print(tab[0])
	return tab[0].points

func load_leaderboard_screen():
	get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _input(event):
	if (event is  InputEventKey and event.scancode == KEY_T ):
		SilentWolf.Scores.persist_score(getNom(), getScore())
		SilentWolf.Scores.get_high_scores()
		load_leaderboard_screen()





func pretPourTour():
	rpc("joueurPretPourTour", Network.id)

signal joueurDePlusPret()
remotesync func joueurPretPourTour(idJoueur):
	if(idJoueur == Network.id):
		self.data.etat = Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE
	self.utilisateurs[idJoueur].etat = Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE
	emit_signal("joueurDePlusPret")
	if(idJoueur == Network.id):
		Network.verifEtat(Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE)
