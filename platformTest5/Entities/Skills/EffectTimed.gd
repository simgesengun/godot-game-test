extends Node
class_name EffectTimed

onready var effect_fsm:Node = get_parent().get_node("EffectFSM")
onready var timer:Timer = get_node("Timer")
signal finished
func _ready():
	connect("finished",effect_fsm,"_effect_finished")
	timer.connect("timeout",self,"_finished")
	_create_effect()

func _create_effect():
	pass

func _finished():
	pass
