extends AnimationTree

onready var playback = self.get("parameters/playback")
var animationCible: String setget setAnimationCible

func _ready():
	self.playback.start("NonExistante")

func _process(delta):
	self.playback.travel( self.animationCible )

func setAnimationCible(nom:String):
	animationCible = nom
