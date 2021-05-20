extends Node

export(String, FILE, "*.ogg") var musiquePath

const PATH_TO_CREDITS: String= "res://Assets/Values/Credits.txt"
var creditTxt: Array = []

onready var ui = $Control
onready var layout = $Control/HBoxContainer/MainLayout

onready var labelTitre = load("res://Scenes/Credits/CreditTitre.tscn").instance()
onready var labelSection = load("res://Scenes/Credits/CreditSection.tscn").instance()
onready var separator = load("res://Scenes/Credits/CreditSeparator.tscn").instance()

var vitesse: float = 0.14

export(float, 1.0, 10.0) var tempsParSection = 1.0

func _ready():
	Music.setMusic(self.musiquePath)
	
	self.importCredits()
	self.initUi()
	
	var timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = float(len(self.creditTxt)) * self.tempsParSection
	timer.connect("timeout", self, "quitter")
	timer.start()

func _process(delta):
	self.ui.anchor_top -= self.vitesse * delta

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		self.quitter()


func importCredits():
	var file: File = File.new()
	file.open(self.PATH_TO_CREDITS, File.READ)
	var txt: String = file.get_as_text()
	file.close()
	
	self.creditTxt = txt.split("\n")


func initUi():
	for txt in self.creditTxt:
		if not txt :
			self.layout.add_child( self.separator.duplicate() )
		
		elif txt[0] == "/":
			txt = txt.replace("/", "")
			var label = self.labelTitre.duplicate()
			self.layout.add_child( label )
			label.text = txt
		
		else:
			var label = self.labelSection.duplicate()
			self.layout.add_child( label )
			label.text = txt


func quitter():
	Globals.optionCache()
	Transition.transitionVers("res://Scenes/MenuPrincipal/MenuPrincipal.tscn")
