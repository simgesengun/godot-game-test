extends Area2D


func _on_Checkpoint_body_entered(_body):
	print("checkpoint entered")
	Global.last_checkpoint = global_position
	yield(get_tree().create_timer(1),"timeout")
	queue_free()
