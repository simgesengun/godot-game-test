extends Area2D

func _on_Timer_timeout():
	queue_free()
	


func _on_Hitbox_area_entered(area):
	print(area.get_parent().name)
