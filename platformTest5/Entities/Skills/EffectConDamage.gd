extends Node

export (int) var damage

onready var effect_fsm:Node = get_parent().get_node("EffectFSM")
onready var timer:Timer = get_node("Timer")
onready var loop_timer:Timer = get_node("LoopTimer")

func _ready():
	timer.connect("timeout",effect_fsm,"_effect_finished")
	loop_timer.connect("timeout", self, "_repeat_me")

func _repeat_me():
	print(damage)
