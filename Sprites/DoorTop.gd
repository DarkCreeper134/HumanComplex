extends StaticBody2D

var Direction = Vector2.DOWN
export var connection = "string"

signal DoorEntered 

func _ready():
	pass 



func _on_Hurtbox_area_entered(area):
	emit_signal("DoorEntered", connection)
