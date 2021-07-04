extends Node2D
onready var DeathPopup = $CanvasLayer/DeathPopup
onready var playerStats = $"/root/PlayerStats"
onready var Keys = $"/root/Keys"
onready var world = $WorldEnvironment
onready var transition = $CanvasLayer/Popup

var StartWorld = preload("res://World/World1.tscn")

var levels = {
A0 = preload("res://World/World1.tscn"),
A1 = preload("res://World/World2.tscn")
}

func _ready():
	Keys.playerCanMove = false
	world.add_child(StartWorld.instance())

func _on_Button_pressed():
	
	Keys.playerCanMove = false
	var childNumber = world.get_child_count()
	world.get_child(childNumber - 1).queue_free()
	world.add_child(StartWorld.instance())
	DeathPopup.hide()
	playerStats.health = playerStats.max_health
	

func onPlayerDeath():
	DeathPopup.show()

func loadLevel(Key, link):
	startTransition()
	var level = levels.get(Key)
	Keys.currentKey = link
	var childNumber = world.get_child_count() - 1
	world.get_child(childNumber).queue_free()
	world.add_child(level.instance())

func startTransition():
	transition.show()

func stopTransition():
	transition.hide()
