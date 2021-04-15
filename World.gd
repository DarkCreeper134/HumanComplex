extends Node2D

onready var Doors = $YSort/Doors
onready var Player = $YSort/Player
onready var Bed = $YSort/Furniture/Bed
onready var PlayPos = Player.position

func _ready():
	pass 

func DoorEntered(connection):
	var connect = Doors.find_node(connection)
	var location = Vector2.ZERO
	var direction = Vector2.ZERO
	location.x = connect.position.x
	location.y = connect.position.y
	direction.x = connect.Direction.x
	direction.y = connect.Direction.y
	var position = Vector2.ZERO
	position.x = location.x + (direction.x * 10)
	position.y = location.y + (direction.y * 10)
	Player.position = position
	Player.input_vector = direction
	Player.DoorEntered()

func BedActivated():
	PlayPos = Player.position
	Player.position.x = Bed.position.x + 1
	Player.position.y = Bed.position.y
	Player.BedActivated()

func BedLeave():
	Player.position = PlayPos
