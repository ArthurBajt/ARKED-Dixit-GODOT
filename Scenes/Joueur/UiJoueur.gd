extends Control

onready var labelPoints = $LabelPoints
onready var labelConteur = $LabelConteur

func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	labelPoints.text = R.getString("labelPoints") % str( Network.data.points )
	labelConteur.text = R.getString("labelConteur")

func _process(delta):
	labelPoints.text = R.getString("labelPoints") % str( Network.data.points )

func changeTheme(theme, estConteur=true, nomConteur=""):
	if(estConteur):
		labelConteur.text = "Vous avez choisi : %s" % theme
	else:
		labelConteur.text = "%s a choisi : %s" % [nomConteur,theme]

func resetTheme():
	labelConteur.text = R.getString("labelConteur")
