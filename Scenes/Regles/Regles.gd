class_name Regles
extends Node

onready var labelTitre = $HBoxContainer/Panel/VBoxContainer/LabelTitre
onready var labelText = $HBoxContainer/Panel/VBoxContainer/LabelText
onready var btnFermer = $ButtonFermer
onready var panel = $HBoxContainer/Panel

func _ready():
	self.cacheR()
	$HBoxContainer/Panel/VBoxContainer/LabelTitre.text = R.getString("reglesTitre")
	$HBoxContainer/Panel/VBoxContainer/LabelText.text = R.getString("reglesText")
	


func afficheR():
	get_parent().move_child( self, get_parent().get_child_count())
	self.visible = true
	btnFermer.rect_position=panel.rect_position
	

func cacheR():
	self.visible = false


func _on_ButtonFermer_pressed():
	self.cacheR()
	



