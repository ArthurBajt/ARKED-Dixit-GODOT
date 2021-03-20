extends Node


func _ready():
	if Globals.isDebug:
		var debugNet = load('res://Scenes/Debug/DebutNetwork.tscn')
		self.add_child(debugNet.instance())

func _process(_delta):
	if Globals.isDebug:
		pass
