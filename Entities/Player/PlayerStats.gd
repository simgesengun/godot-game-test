extends Node

export(int) var max_health setget set_max_health
export(int) var max_speed = 50
onready var health = max_health setget set_health
onready var speed = max_speed setget set_speed

func _ready():
	Events.connect("health_bar_ready",self,"_health_bar_ready")

func set_max_health(value):
	max_health = value
	PlayerEvents.emit_signal("max_health_updated",max_health)

func set_health(value):
	health = clamp(value,0,max_health)
	if health == 0:
		PlayerEvents.emit_signal("no_health")
	else:
		PlayerEvents.emit_signal("health_updated",health)

func set_speed(value):
	speed = value

func _is_immobilized():
	PlayerEvents.emit_signal("immobilized")

func _health_bar_ready():
	PlayerEvents.emit_signal("max_health_updated",max_health)
	PlayerEvents.emit_signal("health_updated",health)
