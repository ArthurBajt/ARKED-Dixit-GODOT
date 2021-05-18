extends Control


onready var buttonNextRound = $PasserLeTourBouton
onready var labelJoueursPrets = $LabelNbJoueursPrets

var joueursPrets = 0
var nbJoueurs


func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.nbJoueurs = Network.utilisateurs.size()
	Network.connect("joueurDePlusPret", self, "joueurDePlusPret")

func _process(delta):
	self.labelJoueursPrets.text = str(self.joueursPrets) + "/" + str(self.nbJoueurs)

signal pretNextRound()
func passerLeTour():
	self.buttonNextRound.visible = false
	emit_signal("pretNextRound")
	
func enlever():
	self.visible = false
	
func afficher():
	self.visible = true
	self.buttonNextRound.visible = true

func joueurDePlusPret():
	self.joueursPrets += 1
	
func resetNbPrets():
	self.joueursPrets = 0
