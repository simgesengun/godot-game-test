extends KinematicBody2D

onready var bullet_scene =preload("res://Entities/Enemies/ShootingFlower/Bullet.tscn")
onready var bullet_spawn = get_node("bullet_spawn")
onready var timer = $Timer
onready var stats = $Stats
enum{
	ACTIVE,
	PASSIVE
}

var state = ACTIVE

func _ready():
	state = ACTIVE

func _physics_process(delta):
	match state:
		ACTIVE:
			pass
		PASSIVE:
			if stats.speed >0:
				state = ACTIVE

func fire():
	Global.instance_node(bullet_scene,bullet_spawn.global_position,get_parent())

func _on_Timer_timeout():
	if state == ACTIVE:
		fire()

func _on_Stats_immobilized():
	state = PASSIVE
