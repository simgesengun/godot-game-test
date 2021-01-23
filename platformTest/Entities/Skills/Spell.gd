extends RigidBody2D

const TARGET_FPS = Engine.iterations_per_second
var original_position
var skill_name
var speed
var damage
var max_distance

onready var sprite = $Sprite

func _ready():
	contact_monitor = true
	contacts_reported = 1
	original_position = position
	match skill_name:
		"Fire":
			damage = 100
			max_distance = 500
			speed = 150
		"Water":
			damage = 50
			max_distance = 500
			speed = 200
	var skill_texture = load("res://Entities/Skills/skill_" + skill_name + ".png")
	sprite.texture = skill_texture
	
func _physics_process(delta):
	apply_impulse(Vector2(),Vector2(speed,0).rotated(rotation))
	print(position.distance_to(original_position))
	if position.distance_to(original_position) > max_distance:
		queue_free()

func _on_Spell_body_entered(body):
	queue_free()
