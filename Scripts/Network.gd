extends Node

const DEFAUT_IP: String = '127.0.0.1'
const DEFAUT_PORT: int = 31400
const MAX_UTILISATEURS: int = 99


var id: int = 0



func _ready():
	get_tree().connect("connected_to_server", self, "_lobby_se_declarer")



func creerServeur(player_name):
	""" Creer un serveur """
	dataStruct.nom = player_name
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAUT_PORT, MAX_UTILISATEURS)
	get_tree().set_network_peer(peer)
	_lobby_se_declarer()


func rejoindreServeur(player_name):
	""" Fait rejoindre un serveur à un utilisateur"""
	dataStruct.nom = player_name
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
					estConteur = false}


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
		rpc_id(1, "_lobby_declareUtilisateur", id)
	
	self.data = dataStruct.duplicate()
	utilisateurs[id] = dataStruct.duplicate()


remote func _lobby_declareUtilisateur(idUtilisateur: int):
	""" Quand un utilisateur se déclare,
	le serveur signal a tt les utilisateur déjà présents
	qu'un nv Utilisateur s'est connecté."""
	for usId in utilisateurs:
		if usId != 1:
			rpc_id(usId, "_lobby_ajouteUtilisateur", idUtilisateur,dataStruct.duplicate())
			rpc_id(idUtilisateur, "_lobby_ajouteUtilisateur", usId, utilisateurs[usId])
		else:
			_lobby_ajouteUtilisateur(idUtilisateur, dataStruct.duplicate())
			rpc_id(idUtilisateur, "_lobby_ajouteUtilisateur", 1, utilisateurs[1])


remote func _lobby_ajouteUtilisateur(idUtilisateur: int, curentData: Dictionary = {}):
	""" Le serveur a declarer l'arrivee d'un nv Utilisateur
	ou
	Nous somme un client arrivant sur le serveur
	
	On met a jour les Utilisateur deja presents et leurs données"""
	if curentData == {}:
		utilisateurs[idUtilisateur] = dataStruct.duplicate()
	else :
		utilisateurs[idUtilisateur] = curentData.duplicate()
	
	emit_signal("nvUtilisateur", idUtilisateur)


func lobby_setStatu(statu: bool):
	""" Permet a un client de changer son statu, si il est pret ou nn."""
	self.data.estPret = statu
	
	if id != 1:
		rpc_id(1, "_lobby_declareStatu", id, statu)
	else:
		_lobby_declareStatu(id, statu)


remote func _lobby_declareStatu(idUtilisateur: int, statu: bool):
	""" Permet au serveur de mettre a jour le statu d'un utilisateur pour tt les autres."""
	for usId in utilisateurs:
		if usId != 1:
			rpc_id(usId, "_lobby_appliquerStatu", idUtilisateur, statu)
		else:
			_lobby_appliquerStatu(idUtilisateur, statu)


remote func _lobby_appliquerStatu(idUtilisateur: int, statu: bool):
	""" change le statu d'un joueur"""
	if (not "estPret" in utilisateurs[idUtilisateur]) or (utilisateurs[idUtilisateur].estPret != statu):
		emit_signal("nvStatuUtilisateur", idUtilisateur, statu)
	
	utilisateurs[idUtilisateur].estPret = statu
	if id == idUtilisateur:
		data.estPret = statu


func lobby_lancerPartie():
	""" Permet a l'hote de la partie de démarer le jeu pour tt les utilisateurs"""
	if id == 1:
		if _peutLancerPartie():
			_lobby_lancePartie()
			for usId in utilisateurs:
				if usId != 1:
					rpc_id(usId, "_lobby_lancePartie")


remote func _lobby_lancePartie():
	""" Signal a tt les utilisateurs du lobby que la partie commence."""
	emit_signal("partieLancee")


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
	if id != 1:
		rpc_id(1, "_partie_declareChargee", id)
	else:
		_partie_declareChargee(1)


remote func _partie_declareChargee(idJoeuur: int):
	""" """
	for usId in utilisateurs:
		if usId != 1:
			rpc_id(usId, "_partie_appliqueChargee", idJoeuur)
		else:
			_partie_appliqueChargee(idJoeuur)


remote func _partie_appliqueChargee(idJoueur: int):
	if idJoueur == id:
		data.estDansPartie = true
	utilisateurs[idJoueur].estDansPartie = true
	
	if id == 1 and _sontJoueursDansPartie():
		emit_signal("JoueursDansPartie")
		print("--JoueursDansPartie--")


func _sontJoueursDansPartie()->bool:
	for usId in utilisateurs:
		if not utilisateurs[usId].estDansPartie:
			return false
	return true


# =================================================
# Cartes

signal joueurApiocherCarte(id, carte)

func joueurPioche(idJoueur: int, carte: String):
	for usId in utilisateurs:
		if usId != 1:
			rpc_id(usId, "_joueurPiocheCarte", idJoueur, carte)
		else:
			_joueurPiocheCarte(idJoueur, carte)


remote func _joueurPiocheCarte(idJoueur: int, carte: String):
	if idJoueur == id:
		self.data.main = self.data.main + [carte]
	utilisateurs[idJoueur].main = utilisateurs[idJoueur].main + [carte]
	emit_signal("joueurApiocherCarte", idJoueur, carte)

# =================================================
# Plateau

signal JoueurPoseCarte(idJoueur, nomCarte)

func posercarte(idJoueur: int, carte: String):
	if id != 1:
		rpc_id(1, "declarePoseCarte", idJoueur, carte)
	else:
		declarePoseCarte(idJoueur, carte)


remote func declarePoseCarte(idJoueur: int, carte: String):
	for usId in utilisateurs:
		if usId != 1:
			rpc_id(usId, "appliquePoseCarte", idJoueur, carte)
		else:
			appliquePoseCarte(idJoueur, carte)


remote func appliquePoseCarte(idJoueur: int, carte: String):
	if idJoueur == self.id:
		print(self.data.main)
		print("nom: ", carte)
		print("main: ", self.data.main.find(carte))
		self.data.cartesPlateau[idJoueur] = carte
		self.data.main.erase(carte)
	
	self.utilisateurs[idJoueur].cartesPlateau[idJoueur] = carte
	self.utilisateurs[idJoueur].main.erase(carte)
	emit_signal("JoueurPoseCarte", idJoueur, carte)
	
# =================================================
# Chat
signal updateChat

func envoieMessage(msg):
	rpc("messageRecu", dataStruct.nom , msg)
	
remotesync func messageRecu(id, msg):
	emit_signal("updateChat", id, msg)
