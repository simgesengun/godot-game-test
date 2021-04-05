extends Node2D


onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer

func update_target_position():
	var target_vector = Vector2(rand_range(-5,5),0)
	target_position = start_position+target_vector


func _on_Timer_timeout():
	update_target_position()
	
func start_timer(duration):
	timer.start(duration)

func get_time_left():
	return timer.time_left
