extends "res://Entities/Skills/EffectTimed.gd"

export (int) var speed

func _create_effect():
	print(speed)

func _finished():
	print("got normal")
	emit_signal("finished")
