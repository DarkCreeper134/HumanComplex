extends StaticBody2D

signal BedActivated

func _ready():
	pass

func _on_Area2D_area_entered(area):
	emit_signal("BedActivated")
