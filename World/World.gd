extends Node2D

onready var Player = $YSort/Player
onready var PlayPos = Player.position
onready var TransitionFrom = $TransitionFrom
onready var timer = $Timer
onready var Keys = $"/root/Keys"
onready var Transition = $Transition/TrasnsitionCover
signal playerDeath
signal nextLevel
signal stopTransition
signal startTransition
var CurrentDoorKey = "A0"
var enteredDoor = false

func _ready():
	connect("playerDeath",get_tree().current_scene,"onPlayerDeath")
	connect("nextLevel",get_tree().current_scene,"loadLevel")
	connect("stopTransition",get_tree().current_scene,"stopTransition")
	connect("startTransition",get_tree().current_scene,"startTransition")
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
	startTransition()
	if IsDoor:
		pass
	else:
		Keys.playerCanMove = false
		emit_signal("startTransition")
		emit_signal("nextLevel",Key, Link)

func _on_Timer_timeout():
	timer.stop()
	var connection = Keys.currentKey
	var door = TransitionFrom.find_node(connection)
	if door != null:
		var location = Vector2.ZERO
		var direction = Vector2.ZERO
		match door.Direction:
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
		position.x = location.x
		position.y = location.y
		Player.position = position
		Player.input_vector = direction
		Player.velocity = Vector2.ZERO
		Player.DoorEntered()
		stopTransition()
		emit_signal("stopTransition")
		Keys.playerCanMove = true

func startTransition():
	Transition.show()

func stopTransition():
	Transition.hide()
