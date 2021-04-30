class_name Options
extends Node

onready var labelTitre = $HBoxContainer/Panel/VBoxContainer/LabelTitre


func _ready():
	self.cache()
	
	$HBoxContainer/Panel/VBoxContainer/LabelTitre.text = R.getString("optionsTitre")
	$HBoxContainer/Panel/VBoxContainer/LabelMusique.text = R.getString("optionsMusique")
	$HBoxContainer/Panel/VBoxContainer/LabelSfx.text = R.getString("optionsSfx")


func affiche():
	get_parent().move_child( self, get_parent().get_child_count())
	self.visible = true


func cache():
	self.visible = false



func _on_ButtonFermer_pressed():
	self.cache()
