extends RigidBody2D

const TARGET_FPS = Engine.iterations_per_second
export(int) var speed
export(int) var damage
export(int) var max_distance
var original_position

func _ready():
	contact_monitor = true
	contacts_reported = 1
	original_position = position

func _physics_process(delta):
	apply_impulse(Vector2(),Vector2(speed,0).rotated(rotation))
	if position.distance_to(original_position) > max_distance:
		queue_free()

func _on_Spell_body_entered(body):
	queue_free()
