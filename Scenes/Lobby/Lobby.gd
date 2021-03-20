extends Node



func _on_ButtonPret_pressed():
	Network.lobby_setStatu(!Network.data.estPret)
