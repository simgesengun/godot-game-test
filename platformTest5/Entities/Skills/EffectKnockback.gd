extends Node
var knockback = Vector2.ZERO
onready var effect_fsm:Node = get_parent().get_node("EffectFSM")
onready var timer:Timer = get_node("Timer")
signal finished
func _ready():
	connect("finished",effect_fsm,"_effect_finished")
	timer.connect("timeout",self,"_finished")
	_create_effect()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	knockback = get_parent().move_and_slide(knockback)

func _create_effect():
	knockback = Global.Player.body.scale.x * Vector2.RIGHT * 200

func _finished():
	emit_signal("finished")
