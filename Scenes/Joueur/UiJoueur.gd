extends Control

onready var labelNom = $VBoxContainer/LabelNom
onready  var labelPoints = $VBoxContainer/LabelPoints
onready var labelConteur = $VBoxContainer/LabelConteur
onready var vboxConteur = $VBoxContainer/VBoxContainerConteur
onready var lineEditTheme = $VBoxContainer/VBoxContainerConteur/HBoxContainer/LineEditTheme
onready var background = $ColorRect
onready var hSperatorNoConteur = null


func _ready():
	labelNom.text = R.getString("labelNom") % str(Network.id)
	labelPoints.text = R.getString("labelPoints") % str( Network.data.points )
	labelConteur.text = R.getString("labelConteur")
	vboxConteur

func afficheUiConteur(isConteur):
	vboxConteur.visible = isConteur
	background.visible = isConteur


func _on_Button_pressed():
	pass # Replace with function body.


func _on_OkButton_pressed():
	var theme = lineEditTheme.text
	if(theme!=null and theme != ""):
		print(theme)
		background.visible = false
		vboxConteur.visible = false
	else:
		# Animation de sursaut
		for i in range(0,2):
			var repetition = 5
			for j in range(0,repetition):
				lineEditTheme.rect_position.y += 1
				yield(get_tree().create_timer(0.01), "timeout")
			for j in range(0,2*repetition):
				lineEditTheme.rect_position.y -= 1
				yield(get_tree().create_timer(0.01), "timeout")
			for j in range(0,repetition):
				lineEditTheme.rect_position.y += 1
				yield(get_tree().create_timer(0.01), "timeout")
		
	# Passer la phrase qqpart (vérifier qu'elle est pas vide)
	# Enlever le UI ou le remplacer
