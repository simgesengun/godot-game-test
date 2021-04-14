extends KinematicBody2D

onready var bullet_scene =preload("res://Entities/Enemies/Wizard/Bullet.tscn")
onready var bullet_spawn = get_node("bullet_spawn")
onready var stats = $Stats
onready var effects_animation = $EffectsAnimation
onready var animation_player = $AnimationPlayer
onready var hitbox = $Hitbox
onready var velocity = Vector2.ZERO
onready var teleport = $Teleport
onready var tp1 = $Teleport/TP1
onready var tp2 = $Teleport/TP2
onready var tp3 = $Teleport/TP3
onready var tp_timer = $TpTimer
var direction = 1
var should_attack
var random_temp
var random = 0
enum{
	IDLE,
	ATTACK,
	FROZEN
}

var state = IDLE

func _ready():
	hitbox.connect("should_attack",self,"_attack_signal")
	stats.connect("no_health",self,"_no_health")
	stats.connect("immobilized",self,"_immobilized")
	teleport.global_position = global_position

func _physics_process(delta):
	velocity.y += 20
	velocity = move_and_slide_with_snap(velocity,Vector2.UP,Vector2(0, 32))

	match state:
		IDLE:
			if tp_timer.time_left == 0:
				_teleport()
			animation_player.play("idle")
			if hitbox.can_attack_player():
				state = ATTACK
		ATTACK:
			if not hitbox.can_attack_player():
				state = IDLE
			else:
				var direction = sign(Global.Player.global_position.x - global_position.x)
				set_global_transform(Transform2D(Vector2(direction,0),Vector2(0,1),Vector2(position.x,position.y)))
		FROZEN:
			if stats.speed >0:
				state = IDLE

func fire():
	var dir = get_angle_to(Global.Player.global_position)
	Global.instance_node_rotated(bullet_scene,bullet_spawn.global_position,get_parent(),dir)

func _on_Timer_timeout():
	if state == ATTACK:
		fire()

func _teleport():
	var tp = _get_teleport_point()
	global_position = tp.global_position
	set_global_transform(Transform2D(Vector2(tp.direction,0),Vector2(0,1),Vector2(position.x,position.y)))
	tp_timer.start()

func _get_teleport_point():
	random_temp = random
	while(random_temp == random):
		random = randi()%3
	match random:
		0:
			return tp1
		1:
			return tp2
		2:
			return tp3
		
		
func _immobilized():
	state = FROZEN

func damaged(amount):
	stats.set_health(stats.health - amount)
	effects_animation.play("Damage")

func _no_health():
	queue_free()
