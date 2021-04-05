extends Area2D

export (int) var bounce = 100
onready var parent = get_parent()

func _on_Jumping_area_entered(area):
	area.get_parent().bounce(bounce)
