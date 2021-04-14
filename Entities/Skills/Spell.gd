extends RigidBody2D

export (int) var speed
export (int) var max_distance
export (PackedScene) var area_of_effect

onready var hitPosition = $HitPosition
onready var parent = get_parent()

var original_position
var look_once = true

func _ready():
	contact_monitor = true
	contacts_reported = 1

func _physics_process(_delta):
	if look_once:
		look_at(get_global_mouse_position())
		original_position = position
		look_once = false

	apply_impulse(Vector2(),Vector2(speed,0).rotated(rotation))
	if position.distance_to(original_position) > max_distance:
		parent.queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	parent.queue_free()

func _on_Spell_body_entered(_body):
	Global.instance_node_rotated(area_of_effect,hitPosition.global_position,get_tree().get_root(),rotation_degrees)
	parent.queue_free()
