extends Node2D

export(int) var max_health = 100
export(int) var max_speed = 50
onready var health = max_health setget set_health
onready var speed = max_speed setget set_speed
onready var parent = get_parent()
onready var effects_animation = parent.get_node("EffectsAnimation")

signal no_health
signal immobilized
signal health_updated

func damage(amount):
	set_health(health - amount)
	effects_animation.play("Damage")

func set_health(value):
	health = clamp(value,0,max_health)
	if health == 0:
		emit_signal("no_health")
	else:
		emit_signal("health_updated")

func set_speed(value):
	speed = value

func _is_immobilized():
	emit_signal("immobilized")
