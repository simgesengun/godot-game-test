extends Node

export (int) var damage

onready var parent = get_parent()
onready var stats = parent.get_node("Stats")
onready var effect_fsm = parent.get_node("EffectFSM")
onready var collision_shape = parent.get_node("CollisionShape2D")
onready var timer = $Timer
onready var particles = $Particles2D

func _ready():
	_adjust_effect() 
	timer.connect("timeout",effect_fsm,"_effect_finished")
	create_effect()

func create_effect():
	parent.damage(damage)

func _adjust_effect():
	particles.process_material.emission_sphere_radius = collision_shape.shape.extents.x
	particles.amount *= collision_shape.shape.extents.x / 10
