extends Node2D
onready var DeathPopup = $CanvasLayer/DeathPopup
onready var playerStats = $"/root/PlayerStats"


var world1 = preload("res://World1.tscn")
var world2 = preload("res://World2.tscn")


func _ready():
	self.add_child(world1.instance())

func _on_Button_pressed():
	var childNumber = self.get_child_count()
	self.get_child(childNumber - 1).queue_free()
	self.add_child(world1.instance())
	DeathPopup.hide()
	playerStats.health = playerStats.max_health
	

func onPlayerDeath():
	DeathPopup.show()

func loadLevel(Key):
	var level = world2
	var childNumber = self.get_child_count()
	self.get_child(childNumber - 1).queue_free()
	self.add_child(level.instance())
	pass
