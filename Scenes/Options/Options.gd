class_name Options
extends Node

onready var labelTitre = $HBoxContainer/Panel/VBoxContainer/LabelTitre


func _ready():
	self.cache()
	
	$HBoxContainer/Panel/VBoxContainer/LabelTitre.text = R.getString("optionsTitre")
	$HBoxContainer/Panel/VBoxContainer/LabelMusique.text = R.getString("optionsMusique")
	$HBoxContainer/Panel/VBoxContainer/LabelSfx.text = R.getString("optionsSfx")
	
	$HBoxContainer/Panel/VBoxContainer/HBoxVolume/SliderVolume.value = AudioServer.get_bus_volume_db( self.busVolume )
	$HBoxContainer/Panel/VBoxContainer/HBoxMusique/SliderMusique.value = AudioServer.get_bus_volume_db( self.busMusic )
	$HBoxContainer/Panel/VBoxContainer/HBoxSfx/SliderSfx.value = AudioServer.get_bus_volume_db( self.busSfx ) 
	


func affiche():
	get_parent().move_child( self, get_parent().get_child_count())
	self.visible = true


func cache():
	self.visible = false



func _on_ButtonFermer_pressed():
	self.cache()


#==========================
#	Changement

# Son
# VOLUME
onready var busVolume = AudioServer.get_bus_index("Master")
func _on_SliderVolume_value_changed(value):
	AudioServer.set_bus_volume_db( self.busVolume, value )
	AudioServer.set_bus_mute( self.busVolume, value <= -50)


# MUSIQUE
onready var busMusic = AudioServer.get_bus_index("Music")
func _on_SliderMusique_value_changed(value):
	AudioServer.set_bus_volume_db( self.busMusic, value )
	AudioServer.set_bus_mute( self.busMusic, value <= -50)


# SFX
onready var busSfx = AudioServer.get_bus_index("Sfx")
func _on_SliderSfx_value_changed(value):
	AudioServer.set_bus_volume_db( self.busSfx, value )
	AudioServer.set_bus_mute( self.busSfx, value <= -50)
