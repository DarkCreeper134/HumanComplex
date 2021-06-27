extends Node2D

export var Key : String = "A0"
export var Link : String = "A0"
export var IsDoor : bool = true
export var ExitFrom : String = "TOP"


signal TrasitionActivated

func _on_Area2D_body_entered(body):
	emit_signal("TrasitionActivated", Key, Link, IsDoor)
