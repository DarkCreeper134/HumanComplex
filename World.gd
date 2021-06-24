extends Node2D

onready var Player = $YSort/Player
onready var PlayPos = Player.position
signal playerDeath
signal nextLevel
func _ready():
	
	connect("playerDeath",get_tree().current_scene,"onPlayerDeath")
	connect("nextLevel",get_tree().current_scene,"loadLevel")

#func DoorEntered(connection):
	#var connect = Doors.find_node(connection)
	#var location = Vector2.ZERO
	#var direction = Vector2.ZERO
	#location.x = connect.position.x
	#location.y = connect.position.y
	#direction.x = connect.Direction.x
	#direction.y = connect.Direction.y
	#var position = Vector2.ZERO
	#position.x = location.x + (direction.x * 10)
	#position.y = location.y + (direction.y * 10)
	#Player.position = position
	#Player.input_vector = direction
	#Player.DoorEntered()

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
	
