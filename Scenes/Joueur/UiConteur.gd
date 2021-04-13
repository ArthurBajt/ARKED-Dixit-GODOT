extends Control


var isChoisingTheme: bool = false


onready var vboxConteur = $VBoxContainer
onready var lineEditTheme = $VBoxContainer/HBoxContainer/LineEditTheme
onready var background = $Background


func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE


func afficheUiConteur(isConteur):
	isChoisingTheme = isConteur
	self.visible = isConteur


func _input(event):
	if(event is InputEventKey):
		if isChoisingTheme and event.pressed and event.scancode == KEY_ENTER:
			valideTheme()


func _on_OkButton_pressed():
	valideTheme()


func valideTheme():
	var theme = lineEditTheme.text
	if(theme!=null and theme != ""):
		print(theme)
		self.visible = false
		isChoisingTheme = false
		Network.defineTheme(theme)
	else:
		# Animation d'erreur
		for _i in range(0,2):
			var repetition = 3
			for _j in range(0,repetition):
				lineEditTheme.rect_position.x += 1
				yield(get_tree().create_timer(0.01), "timeout")
			for _j in range(0,2*repetition):
				lineEditTheme.rect_position.x -= 1
				yield(get_tree().create_timer(0.01), "timeout")
			for _j in range(0,repetition):
				lineEditTheme.rect_position.x += 1
				yield(get_tree().create_timer(0.01), "timeout")
