extends RigidBody2D

var speed = 100
onready var floor_checkers = $FloorCheckers
	
func _physics_process(delta):
	apply_impulse(Vector2(),Vector2(0,speed))
	
	for floor_checker in floor_checkers.get_children():
		if floor_checker.is_colliding():
			yield(get_tree().create_timer(.1), "timeout")
			queue_free()

func _on_visibility_notifier_screen_exited():
	queue_free()

