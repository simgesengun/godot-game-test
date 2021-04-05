extends Area2D

export var damage=1
export var cooldown=0.2
onready var timer = $Timer
var target
var can_attack = true

func _on_Hitbox_area_entered(area):
	target = area.get_parent().get_node("Stats")
	timer.set_wait_time(cooldown)
	timer.start()

func _on_Timer_timeout():
	target.damage(damage)


func _on_Hitbox_area_exited(area):
	timer.stop()
