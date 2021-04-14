extends RigidBody2D

var damage = 100
var speed = 50
onready var floor_checkers = $FloorCheckers
	
func _physics_process(delta):
	apply_impulse(Vector2(),Vector2(speed,0).rotated(rotation_degrees))

func _on_visibility_notifier_screen_exited():
	queue_free()


func _on_Hitbox_area_entered(area):
	area.damaged(self,damage)
	queue_free()
