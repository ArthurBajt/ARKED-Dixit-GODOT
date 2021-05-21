extends Node

const DEFAUT_IP: String = '127.0.0.1'
const DEFAUT_PORT: int = 31400
const MAX_UTILISATEURS: int = 99


var peerServ
var peerClient
var id: int = -1
var nom = ""
var erreur_connexion
var tabCouleur=[Color.rebeccapurple,Color.orange,Color.maroon,Color.cadetblue,Color.red,Color.green]

var withHost = false
var idOneNotHost = false
func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_lobby_se_declarer")
	get_tree().connect("connection_failed", self, "retour_menu")
	get_tree().connect("server_disconnected", self, "deconnexion_server")
	get_tree().connect("network_peer_disconnected", self, "deconnexion_client")

var timer: float
var isTimerRunning: bool = false
func _process(delta):
	if isTimerRunning:
		timer+=delta

func creerServeur(player_name, ip):
	""" Creer un serveur """
#	dataStruct.nom = player_name
	withHost = false
	self.nom = player_name
	peerServ = NetworkedMultiplayerENet.new()
	peerServ.set_bind_ip(ip)
	peerServ.create_server(DEFAUT_PORT, MAX_UTILISATEURS)
	get_tree().set_network_peer(peerServ)
	_lobby_se_declarer()

func hostServeur(ip):
	""" Host un serveur """
	peerServ = NetworkedMultiplayerENet.new()
	withHost = true
	peerServ.set_bind_ip(ip)   # Ip défini à 127.0.0.1 pour le moment
	peerServ.create_server(DEFAUT_PORT, MAX_UTILISATEURS)
	get_tree().set_network_peer(peerServ)
	print("ici eho", peerServ.get_unique_id())
	_lobby_se_declarer()
	
func rejoindreServeur(player_name, ipHote):
	""" Fait rejoindre un serveur à un utilisateur"""
#	dataStruct.nom = player_name
	self.nom = player_name
	peerClient = NetworkedMultiplayerENet.new()
	peerClient.create_client(ipHote, DEFAUT_PORT)
	get_tree().set_network_peer(peerClient)


# =================================================
# Lobby

var utilisateurs: Dictionary
var data: Dictionary
const dataStruct = {nom = "",
					estPlateau = false,
					estPret = false,
					estDansPartie = false,
					main = [],
					cartesPlateau = {},
					carteVotee = null,
					points = 0,
					estConteur = false,
					couleur = Globals.COULEUR_DEFAUT,
					objectif = 30,
					etat = Globals.EtatJoueur.ATTENTE_CHOIX_THEME
					}

var idOneExisting = false
var nbTours = 1
var stats = {	
				sociabilite = {},
				tmpsReac = 	{},
				cartesJouees = {},
				themes = {}
			}
const tmpsReacTour = 	{
						poseCarte = {},
						voteCarte = {},
						voirResultats = {}
						}


signal nvUtilisateur(idUtilisateur)
signal nvStatuUtilisateur(idUtilisateur, statu)
signal partieLancee
signal hotePret

func estHote():
	return (id == 1 and !withHost) or (id == 0 and withHost)

signal hoteTablette

func _lobby_se_declarer():
	
	if peerClient!=null:
		rpc_id(1, "demandeHote", peerClient.get_unique_id())
	
		yield(Network, "hoteTablette")
	
	""" Quand un joueur se connecte au serveur
	Il recupère son ID propre.
	Et déclare sa présence au serveur. """
	
	
	if get_tree().is_network_server() and withHost:
		id = 0
		dataStruct.estPlateau = true
		dataStruct.estPret = true
		print("with host")
	elif get_tree().is_network_server() and !withHost:
		id = 1
		idOneExisting = true

		print("sans host")
	else:
		print("topsdss")
		if !idOneExisting :
			id = 1
			idOneNotHost=true
		else:
			id = get_tree().get_network_unique_id()
	
	if self.nom!="Dieu":
		self.data = dataStruct.duplicate()
		self.data.nom = self.nom
		
		utilisateurs[id] = dataStruct.duplicate()
		utilisateurs[id].nom = self.nom
		
		if id > 1 :
			rpc_id(1, "_lobby_declareUtilisateur", id, self.data)
	else:
		rpc_id(1, "demandeDonnee", id)
		
		yield(Network, "hotePret")
		for usId in utilisateurs:
			if usId !=null:
				emit_signal("nvUtilisateur", usId)
				
	self.data = dataStruct.duplicate()
	self.data.nom = self.nom
		
	if id != 0:
		
		
		utilisateurs[id] = self.dataStruct.duplicate()
		utilisateurs[id].nom = self.nom
		
		
	
	if id > 1 and !withHost:								# NOTE : Peut être check si withHost et donc faire id > 0
		rpc_id(1, "_lobby_declareUtilisateur", id, self.data)
	elif id > 0:
		rpc_id(1, "_lobby_declareUtilisateur", id, self.data)


remote func demandeHote(idJoueur):
	print("machin m'a parlé : ", idJoueur)
	print("mes données c'est : ", self.utilisateurs, "\n")
	rpc_id(idJoueur, "HoteRecu", self.utilisateurs)
	

remote func HoteRecu(donnee):
	if donnee.empty():
		idOneExisting=false
	else:
		idOneExisting = donnee[1]!=null
		
	emit_signal("hoteTablette")

func retour_menu():
	Transition.transitionVers("res://Scenes/MenuPrincipal/MenuPrincipal.tscn")

signal decoJoueur(id, nomCarte, eraseCarte)
signal reVote(idJoueur)
signal changeConteurzer()
func deconnexion_client(id):
	var saveEtat = self.utilisateurs[id].etat
	var saveNomCarte = self.utilisateurs[id].cartesPlateau.get(id)
	var eraseCarte = false
	print("c'est l'id : ", id)
	
	utilisateurs.erase(id)

	for usId in utilisateurs: 
		print(usId)
		

	match saveEtat:
		Globals.EtatJoueur.SELECTION_CARTE_THEME:
			emit_signal("decoJoueur", id, saveNomCarte, eraseCarte)
			emit_signal("changeConteurzer")
			
		Globals.EtatJoueur.CHOIX_THEME:
			for user in self.utilisateurs:
				self.utilisateurs[user].cartesPlateau.erase(id)
			eraseCarte = true
			emit_signal("decoJoueur", id, saveNomCarte, eraseCarte)
			emit_signal("changeConteurzer")
			
		Globals.EtatJoueur.SELECTION_CARTE:
			self.verifEtat(Globals.EtatJoueur.ATTENTE_SELECTIONS)
			emit_signal("decoJoueur", id, saveNomCarte, eraseCarte)
			
		Globals.EtatJoueur.ATTENTE_SELECTIONS:
			self.verifEtat(saveEtat)
			for user in self.utilisateurs:
				self.utilisateurs[user].cartesPlateau.erase(id)
			eraseCarte = true
			emit_signal("decoJoueur", id, saveNomCarte, eraseCarte)
			
		Globals.EtatJoueur.VOTE:
			for user in self.utilisateurs:
				if self.utilisateurs[user].carteVotee == saveNomCarte:
					self.utilisateurs[user].etat=Globals.EtatJoueur.VOTE
					if user == self.id:
						self.data.etat=Globals.EtatJoueur.VOTE
					emit_signal("reVote", user)
			eraseCarte=true
			self.verifEtat(Globals.EtatJoueur.ATTENTE_VOTES)
			emit_signal("decoJoueur", id, saveNomCarte, eraseCarte)
			
		Globals.EtatJoueur.ATTENTE_VOTES:
			self.verifEtat(saveEtat)
			emit_signal("decoJoueur", id, saveNomCarte, eraseCarte)
			
		Globals.EtatJoueur.VOIR_RESULTAT:
			self.verifEtat(Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE)
			emit_signal("decoJoueur", id, saveNomCarte, eraseCarte)
			
		Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE:
			emit_signal("decoJoueur", id, saveNomCarte, eraseCarte)
			self.verifEtat(saveEtat)



func deconnexion_server():
	self.saveJson(self.stats)
	if (self.id!=1 and idOneNotHost) or (!withHost and self.id!=0):
		erreur_connexion = R.getString("networkErrHoteQuitte")

	get_tree().set_network_peer(null)

	self.data={}
	self.data=self.dataStruct.duplicate()
	self.utilisateurs={}
	
	withHost = false
	idOneNotHost = false
	
	retour_menu()

remote func donneeRecu(donnee):
	self.utilisateurs=donnee
	emit_signal("hotePret")

remote func demandeDonnee(idDemande):
	

	rpc_id(idDemande, "donneeRecu", self.utilisateurs)

	



remote func _lobby_declareUtilisateur(idUtilisateur: int, curentData:Dictionary ):
	""" Quand un utilisateur se déclare,
	le serveur signal a tt les utilisateur déjà présents
	qu'un nv Utilisateur s'est connecté."""
	
#	rpc("_lobby_ajouteUtilisateur", idUtilisateur, dataStruct.duplicate())
	rpc("_lobby_ajouteUtilisateur", idUtilisateur, curentData.duplicate() )
	for usId in utilisateurs:
		rpc_id(idUtilisateur,"_lobby_ajouteUtilisateur", usId, utilisateurs[usId])
		#if withHost :
			#rpc_id(0,"_lobby_ajouteUtilisateur", usId, utilisateurs[usId])


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
	if estHote() and _peutLancerPartie():
		rpc("_lobby_lancePartie")


remotesync func _lobby_lancePartie():
	""" Signal a tt les utilisateurs du lobby que la partie commence."""
	timer = 0
	isTimerRunning = true
	self.stats.tmpsReac[nbTours] = tmpsReacTour.duplicate()
	for user in self.utilisateurs:
		self.stats.sociabilite[user] = 0
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
	"""Un est appelée quand un joueur a charger la scene de de la partie."""
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
	if id!=0:
		utilisateurs[idJoueur].estDansPartie = true
	
	if estHote() and _sontJoueursDansPartie():

		
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
	var timerAtThisMoment = timer
	if(idJoueur == self.id):
		self.data.carteVotee = nomCarte
	self.stats.tmpsReac[nbTours].voteCarte[idJoueur] = timerAtThisMoment
	self.utilisateurs[idJoueur].carteVotee = nomCarte

	self.utilisateurs[idJoueur].etat = Globals.EtatJoueur.ATTENTE_VOTES
	emit_signal("carteVotee", nomCarte, idJoueur)
# =================================================
# Cartes

signal joueurApiocherCarte(id, carte, type)

func joueurPioche(idJoueur: int, carte: String, type: int):
	rpc("_joueurPiocheCarte", idJoueur, carte, type)



remotesync func _joueurPiocheCarte(idJoueur: int, carte: String, type: int):
	if idJoueur == id:
		self.data.main = self.data.main + [carte]
	utilisateurs[idJoueur].main = utilisateurs[idJoueur].main + [carte]
	emit_signal("joueurApiocherCarte", idJoueur, carte, type)

# =================================================
# Plateau

signal JoueurPoseCarte(idJoueur, nomCarte)
signal APoseCarte()

func posercarte(idJoueur: int, carte: String):
	rpc("appliquePoseCarte", idJoueur, carte)
	
remotesync func appliquePoseCarte(idJoueur: int, carte: String):
	var timerAtThisMoment = timer
	self.data.cartesPlateau[idJoueur] = carte
	if idJoueur == self.id:
		self.data.main.erase(carte)
	
	for jId in self.utilisateurs:
		self.utilisateurs[jId].cartesPlateau[idJoueur] = carte
	self.utilisateurs[idJoueur].main.erase(carte)
	
	if(!self.utilisateurs[idJoueur].estConteur):
		self.stats.tmpsReac[nbTours].poseCarte[idJoueur] = timerAtThisMoment
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
	rpc("messageRecu", self.id , msg)
	
remotesync func messageRecu(id, msg):
	stats.sociabilite[id] += 1
	var pseudo = self.utilisateurs[id].nom
	emit_signal("updateChat", pseudo, msg)

# =================================================
# Theme
signal updateTheme
func defineTheme(theme):
	rpc("changeTheme", self.id, theme)
	
remotesync func changeTheme(id, theme):
	self.isTimerRunning = false
	var timerAtThisMoment = self.timer
	self.stats.themes[nbTours] = {id: theme}
	for usId in self.utilisateurs:
		if(self.utilisateurs[usId].estConteur):
			self.stats.tmpsReac[nbTours].poseCarte[usId] = timerAtThisMoment
			self.utilisateurs[usId].etat = Globals.EtatJoueur.ATTENTE_SELECTIONS
		else:
			self.utilisateurs[usId].etat = Globals.EtatJoueur.SELECTION_CARTE
	var nomConteur = self.utilisateurs[id].nom
	self.timer = 0
	self.isTimerRunning = true
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
			timer = 0
			self.stats.cartesJouees[self.nbTours] = self.data.cartesPlateau
			if(self.data.estConteur):
				self.data.etat = Globals.EtatJoueur.ATTENTE_VOTES
			else:
				self.data.etat = Globals.EtatJoueur.VOTE
			for user in self.utilisateurs:
				if self.utilisateurs[user].estConteur:
					self.utilisateurs[user].etat=Globals.EtatJoueur.ATTENTE_VOTES
				else:
					self.utilisateurs[user].etat=Globals.EtatJoueur.VOTE
				emit_signal("vote")

					
				print("V1 Etat de %s [%s]: %s" % [utilisateurs[user].nom, user,utilisateurs[user].etat])
		
		elif(etat==Globals.EtatJoueur.ATTENTE_VOTES):
			timer = 0
			self.data.etat = Globals.EtatJoueur.VOIR_RESULTAT
			for user in self.utilisateurs:
				self.utilisateurs[user].etat = Globals.EtatJoueur.VOIR_RESULTAT
			emit_signal("voirRes")
			if(Network.id == idClient):
				self.afficheVoteurs()
				self.calculPoints()
		
		elif(etat==Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE):
			timer = 0
			self.data.cartesPlateau = {}
			self.data.carteVotee = null
			self.data.etat = Globals.EtatJoueur.ATTENTE_CHOIX_THEME
			for user in self.utilisateurs:
				self.utilisateurs[user].cartesPlateau = {}
				self.utilisateurs[user].carteVotee = null
				self.utilisateurs[user].etat = Globals.EtatJoueur.ATTENTE_CHOIX_THEME
			
			var aFini = false
			for user in self.utilisateurs:
				aFini = aFini or self.utilisateurs[user].points>=self.utilisateurs[user].objectif
			if aFini:
				self.saveJson(self.stats)
				emit_signal("finDePartie")
			else:
				self.nbTours += 1
				self.stats.tmpsReac[nbTours] = tmpsReacTour.duplicate()
				emit_signal("prochaineManche")
		
		print("")
		print("stats: ",self.stats)
		print("")

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
	if idJoueur != 0:
		if self.id == idJoueur :
			self.data.couleur = coul
		print(utilisateurs)
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
	

func pretPourTour():
	rpc("joueurPretPourTour", Network.id)

signal joueurDePlusPret()
remotesync func joueurPretPourTour(idJoueur):
	var timerAtThisMoment = timer
	if(idJoueur == Network.id):
		self.data.etat = Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE
	self.stats.tmpsReac[nbTours].voirResultats[idJoueur] = timerAtThisMoment
	self.utilisateurs[idJoueur].etat = Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE
	emit_signal("joueurDePlusPret")
	if(idJoueur == Network.id):
		Network.verifEtat(Globals.EtatJoueur.ATTENTE_PROCHAINE_MANCHE)
		
func rejouer():
	rpc("rejouer_rpc")

signal versLobby()
remotesync func rejouer_rpc():
	self.data.estPret = false
	self.data.estDansPartie = false
	self.data.main = []
	self.data.points = 0
	
	for user in self.utilisateurs:
		self.utilisateurs[user].estPret = false
		self.utilisateurs[user].estDansPartie = false
		self.utilisateurs[user].main = []
		self.utilisateurs[user].points = 0
	
	emit_signal("versLobby")
	
func saveJson(dict):
  var file = File.new()
  file.open("user://stat.json", File.WRITE)
  file.store_string(to_json(dict))
  file.close()
