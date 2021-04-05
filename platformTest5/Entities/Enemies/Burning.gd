extends Area2D

onready var parent= get_parent()
onready var effect_fsm = parent.get_node("EffectFSM")
onready var collision_shape = $CollisionShape2D

func _on_Burning_area_entered(area):
	if area.get_parent().get_node("EffectFSM").state == Global.SE.FIRE:
		if effect_fsm.state == Global.SE.NONE:
			effect_fsm.state_request = Global.SE.FIRE
