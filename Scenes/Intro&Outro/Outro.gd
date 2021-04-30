extends Node


func _ready():
	$Ui/ColorRect/VBoxContainer/outroMessage.text = R.getString("outroMessage")
	$AnimationPlayer.connect("animation_finished", self, "skip")
	$AnimationPlayer.play("outro")


func _input(event):
	if event.is_pressed():
		self.skip()


func skip(_value=null):
	get_tree().quit()
