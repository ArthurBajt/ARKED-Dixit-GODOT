extends Node

const NODE_MUSIQUE_PLAYER = preload("res://Scenes/MusicPlayer/MusicPlayer.tscn")
var player: MusicPlayer
var currentSong: String


func _ready():
	self.player = self.NODE_MUSIQUE_PLAYER.instance()
	self.get_parent().call_deferred("add_child", self.player)


func setMusic(path:String):
	""" Met a jour la musique actuelle"""
	if path == self.currentSong:
		return
	
	if not File.new().file_exists(path): # si le fichier n'existe pas
		push_warning("L'audio "+path+" n'existe pas !")
		return
	
	self.player.changeMusic(path)
	self.currentSong = path


func stop():
	""" Stop la musique actuelle """
	self.player.stop()
	pass
