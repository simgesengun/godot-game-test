extends Node

export (int) var damage
onready var parent = get_parent()
onready var stats = parent.get_node("Stats")
onready var effect_fsm = parent.get_node("EffectFSM")
onready var timer:Timer = get_node("Timer")
signal finished

var knockback = Vector2.ZERO

func _ready():
	connect("finished",effect_fsm,"_effect_finished")
	timer.connect("timeout",self,"_finished")
	parent.damage(damage)
	knockback = Global.Player.body.scale.x * Vector2.RIGHT * 200

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	knockback = parent.move_and_slide(knockback)

func _finished():
	emit_signal("finished")
