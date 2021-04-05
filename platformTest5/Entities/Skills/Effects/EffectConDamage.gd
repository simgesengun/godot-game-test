extends Node

export (int) var damage

onready var parent = get_parent()
onready var effect_fsm:Node = parent.get_node("EffectFSM")
onready var timer = $Timer
onready var loop_timer = $LoopTimer

func _ready():
	timer.connect("timeout",effect_fsm,"_effect_finished")
	loop_timer.connect("timeout", self, "_repeat_me")

func _repeat_me():
	parent.damage(damage)


func _on_Timer_timeout():
	emit_signal("finished")
