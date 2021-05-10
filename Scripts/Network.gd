extends Node

const DEFAUT_IP: String = '127.0.0.1'
const DEFAUT_PORT: int = 31400
const MAX_UTILISATEURS: int = 99


var id: int = 0
var nom = ""


func _ready():
	get_tree().connect("connected_to_server", self, "_lobby_se_declarer")



func creerServeur(player_name):
	""" Creer un serveur """
#	dataStruct.nom = player_name
	self.nom = player_name
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAUT_PORT, MAX_UTILISATEURS)
	get_tree().set_network_peer(peer)
	_lobby_se_declarer()
	
func rejoindreServeur(player_name):
	""" Fait rejoindre un serveur à un utilisateur"""
#	dataStruct.nom = player_name
	self.nom = player_name
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAUT_IP, DEFAUT_PORT)
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
					points = 0,
					estConteur = false,
					couleur = Color.black
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
	
	rpc("assigneCouleur")
	emit_signal("partieLancee")

remotesync func assigneCouleur():
	var tabCouleur=[Color.rebeccapurple,Color.orange,Color.maroon,Color.cadetblue,Color.red,Color.green]
#	randomize()
#	tabCouleur.shuffle()
	for usId in utilisateurs:
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
	print("pouet : ", idJoeuur )
	rpc("_partie_appliqueChargee", idJoeuur)



remotesync func _partie_appliqueChargee(idJoueur: int):
	if idJoueur == id:
		data.estDansPartie = true
	utilisateurs[idJoueur].estDansPartie = true
	
	if id == 1 and _sontJoueursDansPartie():
		print("--JoueursDansPartie--")
		
		emit_signal("JoueursDansPartie")



func _sontJoueursDansPartie()->bool:
	print(utilisateurs.size())
	for usId in utilisateurs:
		print(usId)
		if not utilisateurs[usId].estDansPartie:
			return false
	return true


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
	if idJoueur == self.id:
		self.data.cartesPlateau[idJoueur] = carte
		self.data.main.erase(carte)
	
	self.utilisateurs[idJoueur].cartesPlateau[idJoueur] = carte
	self.utilisateurs[idJoueur].main.erase(carte)
	
	if(!self.utilisateurs[idJoueur].estConteur):
		self.utilisateurs[idJoueur].etat = Globals.EtatJoueur.ATTENTE_SELECTIONS
	else:
		self.utilisateurs[idJoueur].etat = Globals.EtatJoueur.CHOIX_THEME
	
		
	
	emit_signal("JoueurPoseCarte", idJoueur, carte)
	emit_signal("APoseCarte", idJoueur)
	
signal ChangementConteur

func changeConteur(idJoueur):
	rpc("declareChangementConteur", idJoueur)
	
remotesync func declareChangementConteur(idJoueur):
	self.data.estConteur= idJoueur == self.id
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
	
func verifEtat():
	var nbJoueur = utilisateurs.size()
	var compteur = 0
	for usId in self.utilisateurs:
		if (self.utilisateurs[usId].etat==Globals.EtatJoueur.ATTENTE_SELECTIONS):
			compteur+=1
		if (compteur == nbJoueur):
			for user in self.utilisateurs:
				if self.utilisateurs[user].estConteur:
					self.utilisateurs[user].etat=Globals.EtatJoueur.ATTENTE_VOTES
				else:
					self.utilisateurs[user].etat=Globals.EtatJoueur.VOTE
					
				print("V1 Etat de %s [%s]: %s" % [utilisateurs[user].nom, user,utilisateurs[user].etat])


	for usId in self.utilisateurs:
		print("V2 Etat de %s [%s]: %s" % [utilisateurs[usId].nom, usId,utilisateurs[usId].etat])

func couleurJoueur(idJoueur):

	for usId in utilisateurs:
		if usId == idJoueur:
			return utilisateurs[usId].couleur
		
