class_name Options
extends Node

onready var labelTitre = $HBoxContainer/Panel/VBoxContainer/LabelTitre
onready var contMenu = $HBoxContainer/Panel/VBoxContainer/retourMenuCont

func _ready():
	self.cache()
	
	$HBoxContainer/Panel/VBoxContainer/LabelTitre.text = R.getString("optionsTitre")
	$HBoxContainer/Panel/VBoxContainer/LabelMusique.text = R.getString("optionsMusique")
	$HBoxContainer/Panel/VBoxContainer/LabelSfx.text = R.getString("optionsSfx")
	
	$HBoxContainer/Panel/VBoxContainer/HBoxVolume/SliderVolume.value = AudioServer.get_bus_volume_db( self.busVolume )
	$HBoxContainer/Panel/VBoxContainer/HBoxMusique/SliderMusique.value = AudioServer.get_bus_volume_db( self.busMusic )
	$HBoxContainer/Panel/VBoxContainer/HBoxSfx/SliderSfx.value = AudioServer.get_bus_volume_db( self.busSfx )
	
	$HBoxContainer/Panel/VBoxContainer/LabelTailleEcrand.text = R.getString("optionTailleEcrand")
	$HBoxContainer/Panel/VBoxContainer/HBoxContainer/ContainerGrandEcrand/LabelGrandEcrand.text = R.getString("optionTailleEcrandGrand")
	$HBoxContainer/Panel/VBoxContainer/HBoxContainer/ContainerPetitEcrand/LabelPetitEcrand.text = R.getString("optionTailleEcrandPetit")
	
	$HBoxContainer/Panel/VBoxContainer/HBoxContainer/SliderTailleEcrand.min_value = Globals.FOV_MIN
	$HBoxContainer/Panel/VBoxContainer/HBoxContainer/SliderTailleEcrand.max_value = Globals.FOV_MAX
	$HBoxContainer/Panel/VBoxContainer/HBoxContainer/SliderTailleEcrand.value = Globals.FOV_DEFAUT
	$HBoxContainer/Panel/VBoxContainer/HBoxContainer/SliderTailleEcrand.step = (Globals.FOV_MAX - Globals.FOV_MIN) / 15
	
	$HBoxContainer/Panel/VBoxContainer/HBoxContainer/SliderTailleEcrand.connect("value_changed", self, "changeFov")
	
	
	


func affiche():
	get_parent().move_child( self, get_parent().get_child_count())
	self.visible = true
	if get_tree().current_scene.name == "MenuPrincipal":
		contMenu.visible = false
	else:
		contMenu.visible = true

func cache():
	self.visible = false



func _on_ButtonFermer_pressed():
	self.cache()


#==========================
#	Changement Son

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

#==========================
#	Changement Ecrand

func changeFov(val):
	Globals.setFov( $HBoxContainer/Panel/VBoxContainer/HBoxContainer/SliderTailleEcrand.value )


func _on_ResetTailleEcrand_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var fov = Globals.FOV_DEFAUT
			$HBoxContainer/Panel/VBoxContainer/HBoxContainer/SliderTailleEcrand.value = fov
			Globals.setFov(fov)





func _on_retourMenu_pressed():

	if Network.id !=1:
		Network.peerClient.close_connection()
	else:
		Network.peerServ.close_connection()
		
	Network.data={}
	Network.data=Network.dataStruct.duplicate()
	Network.utilisateurs={}
	
	Network.retour_menu()
	cache()


