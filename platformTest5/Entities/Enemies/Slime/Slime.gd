extends KinematicBody2D

var velocity = Vector2()
var direction:int = -1
var friction = 200
onready var animationPlayer = self.get_node("AnimationPlayer")
onready var playerDetectionZone = $PlayerDetectionZone
onready var hitBox = $Hitbox
onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var floor_checker = $floor_checker
onready var state_machine = $StateMachine
onready var effects_animation = $EffectsAnimation
onready var stats = $Stats
onready var should_attack = false

onready var test = $Position2D

func _apply_gravity():
	velocity.y += 20

func _apply_movement():
	velocity = move_and_slide_with_snap(velocity,Vector2.UP,Vector2(0, 32))

func _flip():
	if velocity.x > 0:
		set_global_transform(Transform2D(Vector2(-1,0),Vector2(0,1),Vector2(position.x,position.y)))
	elif velocity.x < 0:
		 set_global_transform(Transform2D(Vector2(1,0),Vector2(0,1),Vector2(position.x,position.y)))
	if is_on_wall() or not floor_checker.is_colliding():
		direction *=  -1

func _idle(delta):
	velocity.x = stats.speed*direction
	velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
	
func _follow(delta):
	var direct = (Global.Player.global_position - global_position).normalized()
	velocity = velocity.move_toward(stats.speed * direct,friction*delta)

func _should_follow():
	if playerDetectionZone.can_see_player():
		return true
	else:
		return false

func _is_frozen(value):
	if value:
		state_machine.set_state("Frozen")

func _should_attack():
	return should_attack

func _on_Hitbox_area_entered(area):
	should_attack = true

func _on_Hitbox_area_exited(area):
	should_attack  = false

