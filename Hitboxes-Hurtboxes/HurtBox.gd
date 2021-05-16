extends Area2D

var invincible = false setget set_invincible

signal invicniblity_started
signal invicniblity_ended

onready var timer = $Timer

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invicniblity_started")
	else:
		emit_signal("invicniblity_ended")

func start_invincibility(duration):
	timer.start(duration)
	self.invincible = true

func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invicniblity_ended():
	monitorable = true


func _on_HurtBox_invicniblity_started():
	set_deferred("monitorable",false)
