class_name MusicPlayer
extends Node

onready var audioPlayer = $AudioStreamPlayer
onready var animPlayer = $AnimationPlayer


func changeMusic(path: String):
	var audio = load(path)
	self.animPlayer.play("fadeOut")
	yield(self.animPlayer, "animation_finished")
	self.audioPlayer.stop()
	self.audioPlayer.stream = audio
	self.audioPlayer.play()
	self.animPlayer.play("fadeIn")
	yield(self.animPlayer, "animation_finished")
	


func stop():
	self.animPlayer.play("fadeOut")
	yield(self.animPlayer, "animation_finished")
	self.audioPlayer.stop()
