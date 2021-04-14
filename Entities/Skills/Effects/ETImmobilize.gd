extends "res://Entities/Skills/Effects/EffectTimed.gd"

signal immobilized
func _create_effect():
	connect("immobilized",stats,"_is_frozen")
	emit_signal("immobilized")
	stats.speed = 0

func _finished():
	stats.speed = stats.max_speed
	emit_signal("finished")
