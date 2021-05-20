extends Control


const NODE_ITEM = preload("res://Scenes/Scores/ItemJoueurScore.tscn")

var listeItems = []

class TriePoints:
	# c'est comme les fonctions discrettes en js.
	# mais en beaucoup moins bien fait
	static func sort(a, b):
		return a>b

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("visibility_changed", self, "update")
	self.visible = false

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_TAB:
			if(event.pressed and !event.echo):
				var users = []
				for user in Network.utilisateurs:
					users.append(user)
				users.sort()
				var points = []
				for user in users:
					points.append(Network.utilisateurs[user].points)
				points.sort_custom(TriePoints, "sort")
				var joueurs = []
				for pointsJ in points:
					for user in Network.utilisateurs:
						if(!(user in joueurs)):
							if(Network.utilisateurs[user].points == pointsJ):
								joueurs.append(user)
								
				for user in joueurs:
					var instance = NODE_ITEM.instance()
					$VBoxContainer/ListItemJoueur.add_child(instance)
					instance.id = user
					listeItems.append(instance)
					
				for item in listeItems:
					$VBoxContainer/ListItemJoueur.move_child(item, listeItems.size() -1)
					
				$BackgroundVbox.rect_size = $VBoxContainer.rect_size
				$BackgroundVbox.rect_position = $VBoxContainer.rect_position
			elif(!event.pressed):
				listeItems = []
				for child in $VBoxContainer/ListItemJoueur.get_children():
					child.queue_free()
			
			self.visible = event.pressed
