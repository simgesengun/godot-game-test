extends Area2D

export (int) var damage
export (int) var skill
var look_once = true
var damaged_targets = []
onready var timer = $Timer
onready var hit = $Particles2D

func _ready():
	hit.emitting = true
	timer.start()
	

func _on_Timer_timeout():
	get_parent().queue_free()


#func _on_AreaOfEffect_body_entered(body):
#	if !damaged_targets.has(body):
#		damaged_targets.append(body)
#		var effect_node = body.get_node("EffectFSM")
#		effect_node.state_request = skill_name
##		print(body.get_node("Effect").state)
##		Global.instance_node(on_enemy,body.global_position-Vector2(0,7),body)


func _on_AreaOfEffect_area_entered(area):
	area.get_parent().damaged(damage)

