extends Area2D

export var damage=1
var target = null

func _on_Hitbox_area_entered(area):
	target = area

func _on_Hitbox_area_exited(area):
	target = null

func _damage():
	target.damaged(self,damage)

func can_attack_player():
	print(target != null)
	return target != null
