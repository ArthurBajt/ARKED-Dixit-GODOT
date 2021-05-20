extends Control


const NODE_OPTIONS = preload("res://Scenes/Options/Options.tscn")
const NODE_CLASSEMENT = preload("res://Scenes/Scores/Scores.tscn")

var uiOptions
var uiClassement

var optionsVisibles: bool = false
var classementVisible: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	uiOptions = NODE_OPTIONS.instance()
	self.add_child(uiOptions)
	uiOptions.connect("fermeOptions", self, "optionFerme")
	
	uiClassement = NODE_CLASSEMENT.instance()
	self.add_child(uiClassement)
	uiClassement.connect("fermeClassement", self, "classementFerme")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ButtonOptions_pressed():
	optionsVisibles = !optionsVisibles
	if(optionsVisibles):
		uiOptions.affiche()
	else:
		uiOptions.cache()

func _on_ButtonScoreboard_pressed():
	classementVisible = !classementVisible
	if(classementVisible):
		uiClassement.afficher()
	else:
		uiClassement.enlever()

func optionFerme():
	optionsVisibles = false
	
func classementFerme():
	classementVisible = false 
