extends Node

export(int) var max_speed = 50
onready var speed = max_speed setget set_speed

export(int) var max_health setget set_max_health
onready var health = max_health setget set_health
onready var health_bar = get_node("../HealthBar")

signal no_health
signal immobilized
signal health_updated(health)
signal max_health_updated(max_health)

func _ready():
	connect("ready",health_bar,"_stats_ready",[self])

func set_max_health(value):
	max_health = value
	emit_signal("max_health_updated",max_health)

func set_health(value):
	health = clamp(value,0,max_health)
	if health == 0:
		emit_signal("no_health")
	else:
		emit_signal("health_updated",health)

func set_speed(value):
	speed = value

func _is_immobilized():
	emit_signal("immobilized")
