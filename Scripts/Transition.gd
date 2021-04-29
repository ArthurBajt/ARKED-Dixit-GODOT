extends Node

const SCENE_TRANSITION = preload("res://Scenes/TransitionScene/TransitionScene.tscn")
var nodeTransition: TransitionScene


func _ready():
	self.nodeTransition = self.SCENE_TRANSITION.instance()
	get_parent().call_deferred("add_child", self.nodeTransition)



func transitionVers( scene: String):
	get_parent().move_child( self.nodeTransition, get_parent().get_child_count() )
	self.nodeTransition.fadeIn()
	yield(self.nodeTransition, "fadeIn")
	get_tree().change_scene(scene)
	yield(get_tree(), "idle_frame")
	get_parent().move_child( self.nodeTransition, get_parent().get_child_count() )
	self.nodeTransition.fadeOut()
