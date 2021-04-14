extends KinematicBody2D

var gravity =10
var velocity = Vector2()
var acceleration = 300
var friction = 200
var direction =-1
onready var playerDetectionZone =$PlayerDetectionZone
onready var sprite = $Sprite
onready var stats = $Stats
onready var state_machine = $StateMachine
onready var effects_animation = $EffectsAnimation
onready var hitbox = $Hitbox
onready var should_attack = false
onready var floor_checker = $FloorChecker

func _ready():
	hitbox.connect("should_attack",self,"_attack_signal")

func _apply_gravity():
	velocity.y += 40


func _apply_movement(_delta):
	velocity = move_and_slide_with_snap(velocity,Vector2.UP,Vector2(0, 32))
	
func _flip():
	set_global_transform(Transform2D(Vector2(direction,0),Vector2(0,1),Vector2(position.x,position.y)))
	
	if is_on_wall() or not floor_checker.is_colliding():
		direction *=  -1

func _idle(delta):
	velocity.x = 0
	
func _follow(delta):
	if Global.Player!=null:
		direction = sign(Global.Player.global_position.x - global_position.x)
		velocity.x = stats.speed*direction
		velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
	
func _should_follow():
	if playerDetectionZone.can_see_player():
		return true
	else:
		return false

func _is_frozen(value):
	if value:
		state_machine.set_state("Frozen")

func _attack_signal(boolean):
	should_attack = boolean
	
func _should_attack():
	return should_attack
	
func damaged(amount):
	stats.set_health(stats.health - amount)
	effects_animation.play("Damage")

