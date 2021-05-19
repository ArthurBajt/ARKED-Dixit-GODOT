extends Panel

onready var editPseudo = $VBoxContainer/HBoxPseudo/EditPseudo
onready var errPseudo = $VBoxContainer/LabelErrpseudo

onready var editIp = $VBoxContainer/HBoxLancer/VBoxRejoindre/HBoxContainer/EditIp
onready var IpHost = $VBoxContainer/HBoxLancer/VBoxCreer/HBoxContainer/IpHost

onready var errIp = $VBoxContainer/HBoxLancer/VBoxRejoindre/LabelErrIp


func _ready():
	self.initUi()
	self.visible = false


func initUi():
	self.editPseudo.text = ""
	
	$VBoxContainer/LabelPanel.text = R.getString("panelJouer")
	$VBoxContainer/HBoxPseudo/Labelpseudo.text = R.getString("panelJouerPseudo")
	self.errPseudo.text = ""
	
	$VBoxContainer/HBoxLancer/VBoxCreer/LabelCreer.text = R.getString("panelJouerCreer")
	$VBoxContainer/HBoxLancer/VBoxCreer/ButtonCreer.text = R.getString("buttonCreer")
	
	$VBoxContainer/HBoxLancer/VBoxRejoindre/LabelRejoindre.text = R.getString("panelJouerRejoindre")
	$VBoxContainer/HBoxLancer/VBoxRejoindre/ButtonRejoindre.text = R.getString("buttonRejoindre")
	
	$VBoxContainer/HBoxLancer/VBoxHost/LabelHost.text = R.getString("panelJouerHost")
	$VBoxContainer/HBoxLancer/VBoxHost/ButtonHost.text = R.getString("buttonHost")
	
	$VBoxContainer/HBoxLancer/VBoxCreer/ButtonCreer.disabled = true
	$VBoxContainer/HBoxLancer/VBoxRejoindre/ButtonRejoindre.disabled = true
	
	self.errIp.text = ""
	$VBoxContainer/HBoxLancer/VBoxCreer/ButtonCreer.disabled = true


func verifPseudo()->bool:
	var res: bool = self.editPseudo.text != ""
	
	if not res:
		self.errPseudo.text = R.getString("errPseudo")
		self.editPseudo.modulate = Color.orange
	
	else:
		self.errPseudo.text = ""
		self.editPseudo.modulate = Color.white

	$VBoxContainer/HBoxLancer/VBoxCreer/ButtonCreer.disabled = not res
	$VBoxContainer/HBoxLancer/VBoxRejoindre/ButtonRejoindre.disabled = not res
	
	return res


func verifIp()-> bool:
	var res: bool = true
	res = res and (self.editIp.text != "")
	res = res and self.verifPseudo()
	
	if res:
		self.errIp.text = ""
		self.editIp.modulate = Color.white
	
	else:
		self.editIp.modulate = Color.orange
		if self.editIp.text == "":
			self.errIp.text = R.getString("errIp")
		else:
			self.errIp.text = ""
	$VBoxContainer/HBoxLancer/VBoxRejoindre/ButtonRejoindre.disabled = not res
	return res


func _on_ImgPseudoAleatoire_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			self.editPseudo.text = "OugaBouuu"
			self.verifPseudo()


func _on_ButtonCreer_pressed():
	if self.verifPseudo():
		Network.creerServeur( self.editPseudo.text, self.IpHost.text )
		Transition.transitionVers("res://Scenes/Lobby/Lobby.tscn")


func _on_ButtonRejoindre_pressed():
	if self.verifPseudo():
		Network.rejoindreServeur( self.editPseudo.text, self.editIp.text )
		Transition.transitionVers("res://Scenes/Lobby/Lobby.tscn")


func _on_EditPseudo_text_changed():
	if "\n" in self.editPseudo.text:
		self.editPseudo.text = self.editPseudo.text.replace("\n", "")
	self.verifPseudo()
	self.verifIp()


func _on_EditIp_text_changed():
	if "\n" in self.editIp.text:
		self.editIp.text = self.editIp.text.replace("\n", "")
	self.verifPseudo()
	self.verifIp()


func _on_IpHost_text_changed():
	if "\n" in self.IpHost.text:
		self.IpHost.text = self.IpHost.text.replace("\n", "")


func _on_ButtonHost_pressed():
#	TODO : call à la fonction qui creer un serveur, puis transition vers le Lobby
#	Transition.transitionVers("res://Scenes/Lobby/Lobby.tscn")
	pass # Replace with function body.


func _on_ButtonFermer_pressed():
	self.visible = false








