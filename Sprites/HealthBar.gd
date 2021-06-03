extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $Full
onready var heartUIEmpty = $Empty
onready var floatHealth = float(hearts)
onready var floatMaxHealth = float(max_hearts)
onready var healthPercent = floatHealth / floatMaxHealth

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	floatHealth = float(hearts)
	healthPercent = floatHealth/floatMaxHealth
	if heartUIFull != null:
		heartUIFull.rect_size.x = healthPercent * 160

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	floatHealth = float(hearts)
	floatMaxHealth = float(max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = healthPercent * 160

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
