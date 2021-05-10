extends Panel

onready var editPseudo = $VBoxContainer/HBoxPseudo/EditPseudo
onready var errPseudo = $VBoxContainer/LabelErrpseudo


func _ready():
	self.initUi()


func initUi():
	self.editPseudo.text = ""
	
	$VBoxContainer/LabelPanel.text = R.getString("panelJouer")
	$VBoxContainer/HBoxPseudo/Labelpseudo.text = R.getString("panelJouerPseudo")
	self.errPseudo.text = ""
	
	$VBoxContainer/HBoxLancer/VBoxCreer/LabelCreer.text = R.getString("panelJouerCreer")
	$VBoxContainer/HBoxLancer/VBoxCreer/ButtonCreer.text = R.getString("buttonCreer")
	
	$VBoxContainer/HBoxLancer/VBoxRejoindre/LabelRejoindre.text = R.getString("panelJouerRejoindre")
	$VBoxContainer/HBoxLancer/VBoxRejoindre/ButtonRejoindre.text = R.getString("buttonRejoindre")
	
	$VBoxContainer/HBoxLancer/VBoxCreer/ButtonCreer.disabled = true
	$VBoxContainer/HBoxLancer/VBoxRejoindre/ButtonRejoindre.disabled = true


func verifPseudo()->bool:
	var res: bool = self.editPseudo.text != ""
	
	if not res:
		self.errPseudo.text = R.getString("errPseudo")
	
	else:
		self.errPseudo.text = ""
	
	$VBoxContainer/HBoxLancer/VBoxCreer/ButtonCreer.disabled = not res
	$VBoxContainer/HBoxLancer/VBoxRejoindre/ButtonRejoindre.disabled = not res
	
	return res


func _on_ImgPseudoAleatoire_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			self.editPseudo.text = "OugaBouuu"
			self.verifPseudo()


func _on_ButtonCreer_pressed():
	if self.verifPseudo():
		Network.creerServeur( self.editPseudo.text )
		Transition.transitionVers("res://Scenes/Lobby/Lobby.tscn")


func _on_ButtonRejoindre_pressed():
	if self.verifPseudo():
		Network.rejoindreServeur( self.editPseudo.text )
		Transition.transitionVers("res://Scenes/Lobby/Lobby.tscn")


func _on_EditPseudo_text_changed():
	self.verifPseudo()


func _on_ButtonFermer_pressed():
	self.visible = false
