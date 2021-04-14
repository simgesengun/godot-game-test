extends KinematicBody2D

var velocity = Vector2.ZERO
var direction:int = 1
var friction = 200
onready var animationPlayer = self.get_node("AnimationPlayer")
onready var playerDetectionZone = $PlayerDetectionZone
onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var floor_checker = $floor_checker
onready var state_machine = $StateMachine
onready var hurtbox = $HurtBox
onready var stats = $Stats
onready var health_bar = $HealthBar
onready var effects_animation = $EffectsAnimation
onready var should_attack = false

func _ready():
	hitbox.connect("should_attack",self,"_attack_signal")

func _apply_gravity():
	velocity.y += 20

func _apply_movement(_delta):
	velocity = move_and_slide_with_snap(velocity,Vector2.UP,Vector2(0, 32))

func _flip():
	if is_on_wall() or not floor_checker.is_colliding():
		direction *=  -1
	set_global_transform(Transform2D(Vector2(direction,0),Vector2(0,1),Vector2(position.x,position.y)))

func _idle(delta):
	velocity.x = stats.speed*direction
	velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
	
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

func _attack_signal(boolean):
	should_attack = boolean
	
func _should_attack():
	return should_attack

func respawn():
	Global.respawn(self)
	stats.health = stats.max_health

func damaged(amount):
	stats.set_health(stats.health - amount)
	effects_animation.play("Damage")
