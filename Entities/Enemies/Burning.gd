extends Area2D

onready var parent= get_parent()
onready var collision_shape = $CollisionShape2D
onready var skill = Global.SE.FIRE

func _ready():
	collision_shape.shape.radius = parent.get_node("EnemyHurtbox/CollisionShape2D").shape.radius
