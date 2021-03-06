extends Control


var isChoisingTheme: bool = false


onready var vboxConteur = $VBoxContainer
onready var imageCarte = $VBoxContainer/HBoxContainer2/ImageCarte
onready var labelIndicator = $VBoxContainer/LabelChoixTheme
onready var lineEditTheme = $VBoxContainer/HBoxContainer/LineEditTheme
onready var hboxConteur = $VBoxContainer/HBoxContainer
onready var background = $Background


func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	afficheChargement()

func afficheChargement():
	self.visible = true
	imageCarte.visible = false
	hboxConteur.visible = false
	labelIndicator.text = "En attente de tous les joueurs..."

func afficheUiConteur(nomCarte):
	isChoisingTheme = true
	
	self.visible = true
	imageCarte.visible = true
	imageCarte.texture = R.getCarte(nomCarte).duplicate()
	imageCarte.texture.size = Vector2(266,384)
	labelIndicator.text = "Choisissez le thème..."
	hboxConteur.visible = true
	lineEditTheme.text = ""
	
func attendreChoixConteur():
	self.visible = true
	imageCarte.visible = false
	labelIndicator.text = "En attente de la sélection du conteur..."
	hboxConteur.visible = false

func attendreSelections():
	self.visible = true
	imageCarte.visible = false
	labelIndicator.text = "En attente de la sélection des autres joueurs..."
	hboxConteur.visible = false
	
func attendreVotes():
	self.visible = true
	imageCarte.visible = false
	labelIndicator.text = "En attente de tous les votes..."
	hboxConteur.visible = false

func enlever():
	self.visible = false
	
func _input(event):
	if(event is InputEventKey):
		if isChoisingTheme and event.pressed and event.scancode == KEY_ENTER:
			valideTheme()


func _on_OkButton_pressed():
	valideTheme()


func valideTheme():
	var theme = lineEditTheme.text
	if(theme!=null and theme != ""):
		self.visible = false
		isChoisingTheme = false
		Network.defineTheme(theme)
	else:
		# Animation d'erreur
		for _i in range(0,2):
			var repetition = 3
			for _j in range(0,repetition):
				lineEditTheme.rect_position.x += 1
				yield(get_tree().create_timer(0.01), "timeout")
			for _j in range(0,2*repetition):
				lineEditTheme.rect_position.x -= 1
				yield(get_tree().create_timer(0.01), "timeout")
			for _j in range(0,repetition):
				lineEditTheme.rect_position.x += 1
				yield(get_tree().create_timer(0.01), "timeout")


