extends Area2D
export (NodePath) var stats_path
export (NodePath) var knockback_raycast_path
onready var parent = get_parent()
onready var stats = get_node(stats_path)
onready var knockback_raycast = get_node(knockback_raycast_path)
var knockback_direction

func knockback():
	knockback_raycast.cast_to.x = knockback_direction * 28
	if !knockback_raycast.is_colliding():
		parent.global_position.x += knockback_direction * 10

func damaged(enemy, amount):
	knockback_direction =  sign(parent.global_position.x - enemy.global_position.x)
	stats.set_health(stats.health - amount)
