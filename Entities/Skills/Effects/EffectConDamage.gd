extends Node

export (int) var damage
onready var burning = load("res://Entities/Enemies/Burning.tscn")
onready var parent = get_parent()
onready var effect_fsm:Node = parent.get_node("EffectFSM")
onready var collision_shape:CollisionShape2D = parent.get_node("EnemyHurtbox/CollisionShape2D")
onready var timer = $Timer
onready var loop_timer = $LoopTimer

signal burning

func _ready():
	timer.connect("timeout",effect_fsm,"_effect_finished")
	loop_timer.connect("timeout", self, "_repeat_me")
	Global.instance_node(burning,parent.global_position,parent)

func _repeat_me():
	parent.damaged(damage)

func _on_Timer_timeout():
	emit_signal("finished")
