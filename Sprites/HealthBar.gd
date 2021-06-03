extends Control

var hearts = 4.0 setget set_hearts
var max_hearts = 4.0 setget set_max_hearts

onready var heartUIFull = $Full
onready var heartUIEmpty = $Empty
onready var healthPercent = (float(hearts) / float(max_hearts))

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	var healthPercent = hearts / max_hearts
	if heartUIFull != null:
		heartUIFull.rect_size.x = int(healthPercent) * 160

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = (hearts/max_hearts) * 160

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
