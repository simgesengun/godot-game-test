extends Area2D

onready var collisionShape = $CollisionShape2D
onready var parent = get_parent()
onready var effect_fsm = parent.get_node("EffectFSM")
export (Array, bool) var effected_by = [false,false,false,false,false]


func _on_EnemyHurtbox_area_entered(area):
	if effected_by[area.skill]:
		effect_fsm.state_request = area.skill
