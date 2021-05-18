extends Control

var message: String = "" setget setMessage

onready var label = $HBoxContainer/VBoxContainer/Panel/VBoxContainer/LabelErr

func _ready():
	pass


func setMessage(mess: String):
	self.label.text = mess
	message = mess


func _on_ButtonOk_pressed():
	self.queue_free()
