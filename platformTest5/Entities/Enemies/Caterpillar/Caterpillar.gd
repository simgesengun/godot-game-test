extends StaticBody2D

onready var player_detection_zone = $PlayerDetectionZone
onready var area = preload("res://Entities/Enemies/Caterpillar/Area.tscn")
var can_look = true

func _physics_process(delta):
	if can_look:
		if player_detection_zone.can_see_player():
			can_look = false
			yield(get_tree().create_timer(.5), "timeout")
			Global.instance_node(area,Global.Player.get_node("PlayerGround").global_position,get_parent())
			yield(get_tree().create_timer(10), "timeout")
			can_look = true


