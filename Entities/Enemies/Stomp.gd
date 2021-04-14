extends Area2D

export (NodePath) var stats_path
onready var stats = get_node(stats_path)


func _on_Stomp_area_entered(area):
	area.get_parent().bounce(200)
	stats.set_health(0)
