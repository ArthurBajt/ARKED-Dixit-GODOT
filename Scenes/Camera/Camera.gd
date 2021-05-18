extends Camera


var targetFov


func _ready():
	Globals.connect("fovChanged", self, "changeFov")
	self.targetFov = Globals.fov
	self.fov = Globals.fov
	print(Globals.fov)


func _process(delta):
	if self.fov != self.targetFov:
		self.fov = lerp( self.fov, self.targetFov, 5.0 * delta )


func changeFov( val ):
	self.targetFov = val
