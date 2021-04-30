class_name TransitionScene
extends Control


func _ready():
	self.visible = false


signal fadeIn
func fadeIn():
	self.visible = true
	$AnimationPlayer.play("fadeIn")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("fadeIn")


signal fadeOut
func fadeOut():
	emit_signal("fadeOut")
	$AnimationPlayer.play("fadeOut")
	yield($AnimationPlayer, "animation_finished")
	self.visible = false
