extends Node2D
onready var DeathPopup = $CanvasLayer/DeathPopup
onready var playerStats = $"/root/PlayerStats"

var StartWorld = preload("res://World1.tscn")

var levels ={
AO = preload("res://World1.tscn"),
A1 = preload("res://World2.tscn")
}

func _ready():
	self.add_child(StartWorld.instance())

func _on_Button_pressed():
	var childNumber = self.get_child_count()
	self.get_child(childNumber - 1).queue_free()
	self.add_child(StartWorld.instance())
	DeathPopup.hide()
	playerStats.health = playerStats.max_health
	

func onPlayerDeath():
	DeathPopup.show()

func loadLevel(Key, link):
	var level = levels.get(Key)
	var childNumber = self.get_child_count()
	self.get_child(childNumber - 1).queue_free()
	self.add_child(level.instance())
	pass
