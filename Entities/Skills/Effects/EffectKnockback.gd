extends Node

onready var parent = get_parent()
onready var stats = parent.get_node("Stats")
onready var effect_fsm = parent.get_node("EffectFSM")
onready var timer:Timer = get_node("Timer")
signal finished

var knockback:Vector2 = Vector2.ZERO

func _ready():
	connect("finished",effect_fsm,"_effect_finished")
	timer.connect("timeout",self,"_finished")
	knockback.x  = sign(parent.global_position.x - Global.Player.global_position.x)*200

func _physics_process(delta):
	knockback = parent.move_and_slide(knockback)

func _finished():
	emit_signal("finished")

#func knockback(parent,amount):
#	var knockback_raycast = parent.get_node("KnockbackRaycast")
#	var direction = sign(parent.global_position.x - Global.Player.global_position.x)
#	knockback_raycast.cast_to.x = direction * amount
#	if !knockback_raycast.is_colliding():
#		print("knockback!")
#		knockback = Vector2(direction * amount,0)
#	else:
#		print("cant knockback")
##		var distance = abs(parent.get_global_transform().origin.distance_to(knockback_raycast.get_collision_point()))
##		knockback = Vector2(direction * distance,0)
