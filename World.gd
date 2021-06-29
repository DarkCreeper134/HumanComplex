extends Node2D

onready var Player = $YSort/Player
onready var PlayPos = Player.position
onready var Doors = $Doors
onready var timer = $Timer
signal playerDeath
signal nextLevel
signal LevelReady
var CurrentDoorKey = "A0"
var enteredDoor = false

func _ready():
	connect("playerDeath",get_tree().current_scene,"onPlayerDeath")
	connect("nextLevel",get_tree().current_scene,"loadLevel")
	connect("LevelReady",get_tree().current_scene,"LevelReady")
	emit_signal("LevelReady")
	

func DoorEntered(connection):
	CurrentDoorKey = connection
	timer.start(1)

#func BedActivated():
	#PlayPos = Player.position
	#Player.position.x = Bed.position.x + 1
	#Player.position.y = Bed.position.y
	#Player.BedActivated()

#func BedLeave():
	#Player.position = PlayPos

func _on_Player_playerDeath():
	emit_signal("playerDeath")

func _on_Button_pressed():
	pass

func _on_Transition_TrasitionActivated(Key, Link, IsDoor):
	if IsDoor:
		pass
	else:
		emit_signal("nextLevel",Key, Link)

func _on_Timer_timeout():
	var connection = CurrentDoorKey
	var door = Doors.find_node(connection)
	if door != null:
		var location = Vector2.ZERO
		var direction = Vector2.ZERO
		match door.ExitFrom:
			"TOP":
				direction = Vector2.UP
			"BOTTOM":
				direction = Vector2.DOWN
			"LEFT":
				direction = Vector2.LEFT
			"RIGHT":
				direction = Vector2.RIGHT
		location.x = door.position.x
		location.y = door.position.y
		var position = Vector2.ZERO
		position.x = location.x + (direction.x * 30)
		position.y = location.y + (direction.y * 30)
		Player.position = position
		Player.input_vector = direction
		Player.velocity = Vector2.ZERO
		Player.DoorEntered()
