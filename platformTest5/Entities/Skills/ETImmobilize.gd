extends "res://Entities/Skills/EffectTimed.gd"

func _create_effect():
	print("immobilized")

func _finished():
	print("got normal")
	emit_signal("finished")
