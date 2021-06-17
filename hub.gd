extends Node2D
onready var DeathPopup = $CanvasLayer/DeathPopup
onready var playerStats = $"/root/PlayerStats"


var world = preload("res://World1.tscn")

func _ready():
	self.add_child(world.instance())

func _on_Button_pressed():
	var childNumber = self.get_child_count()
	self.get_child(childNumber - 1).queue_free()
	self.add_child(world.instance())
	DeathPopup.hide()
	playerStats.health = playerStats.max_health
	

func onPlayerDeath():
	DeathPopup.show()
	
