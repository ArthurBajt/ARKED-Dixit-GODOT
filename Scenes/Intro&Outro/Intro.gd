extends Node

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "skip")
	
	$Ui/Bk/VBoxContainer/disclamer.text = R.getString("introDisclamer")
	$Ui/Bk/VBoxContainer2/copyRight.text = R.getString("copyright")
	$AnimationPlayer.play("intro")


func _input(event):
	if event.is_pressed():
		self.skip()

func skip(_value=null):
	$AnimationPlayer.disconnect("animation_finished", self, "skip")
	Transition.transitionVers("res://Scenes/MenuPrincipal/MenuPrincipal.tscn")
