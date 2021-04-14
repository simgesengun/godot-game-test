extends Node
class_name EffectTimed

onready var parent = get_parent()
onready var stats = parent.get_node("Stats")
onready var effect_fsm = parent.get_node("EffectFSM")
onready var timer:Timer = get_node("Timer")
onready var collision_shape:Node = parent.get_node("CollisionShape2D")

signal finished
func _ready():
	_adjust_effect()
	connect("finished",effect_fsm,"_effect_finished")
	timer.connect("timeout",self,"_finished")
	_create_effect()

func _create_effect():
	pass

func _finished():
	pass

func _adjust_effect():
	pass
