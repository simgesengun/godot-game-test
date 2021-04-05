extends KinematicBody2D


var gravity =10
var velocity = Vector2()
var acceleration = 300
var friction = 200
export var direction =-1
onready var controller = $Controller
onready var playerDetectionZone =$PlayerDetectionZone
onready var sprite = $Sprite
onready var stats = $Stats
onready var state_machine = $StateMachine
onready var effects_animation = $EffectsAnimation
onready var should_attack = false


func _apply_gravity():
	velocity.y += 20

func _flip():
	sprite.flip_h = velocity.x > 0
	if is_on_wall():
		direction = direction * -1

func _idle(delta):
	if controller.get_time_left() == 0:
		state_machine.pick_random_state()
		controller.start_timer(rand_range(1,3))
	velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
	velocity = move_and_slide(velocity,Vector2.UP)

func _walk(delta):
	velocity.x = stats.speed*direction
	if controller.get_time_left() == 0:
		state_machine.pick_random_state()
		controller.start_timer(rand_range(1,3))
	velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
	velocity = move_and_slide(velocity,Vector2.UP)

func _follow(delta):
	var direct = (Global.Player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direct*stats.speed,acceleration*delta)
	velocity = move_and_slide(velocity,Vector2.UP)


func _attack():
	if should_attack == false:
		if controller.get_time_left() == 0:
			state_machine.pick_random_state()
			controller.start_timer(rand_range(1,3))
			velocity = move_and_slide(velocity,Vector2.UP)


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
	should_attack = false

func damage(amount):
	stats.set_health(stats.health - amount)
	effects_animation.play("Damage")
