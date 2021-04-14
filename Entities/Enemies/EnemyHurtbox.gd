extends Area2D

export (Array, bool) var effected_by = [false,false,false,false,false]
export (NodePath) var effect_fsm_path

onready var effect_fsm = get_node(effect_fsm_path)

func _on_EnemyHurtbox_area_entered(area):
	if effected_by[area.skill]:
		effect_fsm.state_request = area.skill
