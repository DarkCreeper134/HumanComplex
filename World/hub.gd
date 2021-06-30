extends Node2D
onready var DeathPopup = $CanvasLayer/DeathPopup
onready var playerStats = $"/root/PlayerStats"
onready var Keys = $"/root/Keys"

var StartWorld = preload("res://World/World1.tscn")

var levels = {
A0 = preload("res://World/World1.tscn"),
A1 = preload("res://World/World2.tscn")
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
	Keys.currentKey = link
	var childNumber = self.get_child_count() - 1
	self.get_child(childNumber).queue_free()
	self.add_child(level.instance())

func LevelReady():
	pass
