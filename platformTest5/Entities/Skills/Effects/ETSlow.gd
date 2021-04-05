extends "res://Entities/Skills/Effects/EffectTimed.gd"

export (int) var slow

func _create_effect():
	stats.speed -=slow

func _finished():
	stats.speed +=slow
	emit_signal("finished")

func _adjust_effect():
	$Particles2D.process_material.emission_sphere_radius = collision_shape.shape.extents.x * 0.8
	$Particles2D.amount *= collision_shape.shape.extents.x / 10
