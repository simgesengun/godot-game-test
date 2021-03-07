extends Node

onready var parent:KinematicBody2D = get_parent()
onready var effect_fsm:Node = parent.get_node("EffectFSM")

signal finished
func _ready():
	connect("finished",effect_fsm,"_effect_finished")
	create_effect()

func create_effect():
	print("burst")
	emit_signal("finished")
