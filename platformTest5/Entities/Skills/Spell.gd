extends RigidBody2D

const TARGET_FPS = Engine.iterations_per_second
var original_position
export (int) var speed
export (int) var max_distance
var look_once = true

onready var hitPosition = $AnimatedSprite/HitPosition

func _ready():
	contact_monitor = true
	contacts_reported = 1

func _physics_process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		original_position = position
		look_once = false

	apply_impulse(Vector2(),Vector2(speed,0).rotated(rotation))
	if position.distance_to(original_position) > max_distance:
		get_parent().queue_free()

func _on_Spell_body_entered(body):
	var aoe = load("res://Entities/Skills/" + get_parent().name +"AOE.tscn")
	#print("Loaded AOE: res://Entities/Skills/" + skill_name +"AOE.tscn")
	#print("AOE created at:")
	#print(hitPosition.global_position)
	Global.instance_node_deferred(aoe,hitPosition.global_position,get_parent().get_parent())
	get_parent().queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	get_parent().queue_free()
