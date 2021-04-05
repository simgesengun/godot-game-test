extends KinematicBody2D

#constants
#movement
const GRAVITY = 10
const JUMP_FORCE = 288
const SPEED = 128
const CRAWL_SPEED = 32
const SLOPE_STOP = 64

#degrees
const SPI = 3.14
const THREE_COUNTER_SPI = SPI * 3 / 4
const COUNTER_SPI = SPI  / 4
const HALF_SPI = 1.57

#variables
var selected_skill
var can_fire = true
var rate_of_fire = 0.2
var motion = Vector2.ZERO
var is_grounded

onready var hurtbox = $HurtBox
onready var stats = $Stats
#not used yet
var can_jump = true
var jump_was_pressed = false

#state machine
onready var stateMachine = $StateMachine
onready var label = $Label
onready var label2 = $Label2

#timers
onready var coyoteTimer = $CoyoteTimer
onready var jumpPressedTimer = $JumpPressedTimer

#collisions and raycasts
onready var crouch_collision = $CrouchCollision
onready var stand_collision = $StandCollision
onready var raycasts = $Raycasts
onready var can_stand_raycasts = $CanStandRaycasts

#body parts
onready var body = $Body
#onready var arm = $Body/Sprite/Arm
#onready var wandPoint = $Body/Sprite/Arm/WandPoint
onready var test = $TEST

func _ready():
	Global.register_player(self)

func _process(delta):
	var fps = Engine.get_frames_per_second()
	var lerp_interval = motion / fps
	var lerp_position = global_transform.origin + lerp_interval
	
	if fps > 60:
		body.set_as_toplevel(true)
		body.global_transform.origin = body.global_transform.origin.linear_interpolate(lerp_position,20*delta)
	else:
		body.global_transform = global_transform
		body.set_as_toplevel(false)

func _apply_gravity(delta):
	print(test.global_position.y)
	#apply gravity
	
	motion.y += GRAVITY

func _apply_movement():
	#Apply motion
	#motion = move_and_slide(motion, Vector2.UP, SLOPE_STOP)
	motion = move_and_slide_with_snap(motion, Vector2(0, motion.y), Vector2.UP, true)
	is_grounded = check_is_grounded()

func _handle_movement(delta,var speed = self.SPEED):
	#get motion.x
	var move_direction = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	motion.x = lerp(motion.x,speed*move_direction,_get_h_weight())

func check_is_grounded() -> bool:
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _get_h_weight() -> float:
	if is_grounded:
		return 0.2
	else:
		return 0.1

func _jump():
	motion.y = -JUMP_FORCE

func can_stand() -> bool:
	for raycast in can_stand_raycasts.get_children():
		if raycast.is_colliding():
			print(raycast.get_collider())
			return false
	return true

func _on_crouch():
	stand_collision.disabled = true
	crouch_collision.disabled = false

func _on_stand():
	while stand_collision.disabled && !stateMachine.is_crouching():
		if can_stand():
			stand_collision.disabled = false
			crouch_collision.disabled = true
		yield(get_tree(),"physics_frame")

func _attack():
	pass
#	label2.text = "+ ATTACK"
#	can_fire = false
#	var temp = arm.rotation_degrees
#	arm.rotation_degrees +=20
#	yield(get_tree().create_timer(0.1),"timeout")
#	arm.rotation_degrees = temp
#	var skill = load("res://Entities/Skills/" + selected_skill +".tscn")
#	Global.instance_node(skill,wandPoint.global_position,get_parent())
#	yield(get_tree().create_timer(rate_of_fire),"timeout")
#	label2.text = ""
#	can_fire = true

func _on_Stats_no_health():
	queue_free()

func bounce(value):
	motion.y = -value

func _handle_direction():
	pass
#	var mouse_pos = get_global_mouse_position()
#	mouse_pos = Vector2(int(mouse_pos.x), int(mouse_pos.y))
#	var pos = get_local_mouse_position()
#	if (pos.angle()>=COUNTER_SPI and pos.angle()<=HALF_SPI) or (pos.angle()>=HALF_SPI and pos.angle()<=THREE_COUNTER_SPI):
#		pass
#	else:
#		arm.look_at(mouse_pos)
#		if pos.angle() > -HALF_SPI and pos.angle() < HALF_SPI:
#			if body.scale.x < 0:
#					body.scale.x *= -1
#		else:
#			if body.scale.x > 0:
#				body.scale.x *= -1
#
#		if (pos.angle()>0 and pos.angle()<HALF_SPI) or (pos.angle()>HALF_SPI and pos.angle()<SPI):
#			if arm.scale.y > 0:
#				arm.scale.y *= -1
#			arm.position.y = -5
#		else:
#			if arm.scale.y < 0:
#				arm.scale.y *= -1
#			arm.position.y = 0

#	var x_input = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
#
#	if x_input!=0:
#		#animationPlayer.play("Run")
#		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
#		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
#	else:
#		animationPlayer.play("Idle")
#
#	if Input.is_action_just_pressed("ui_up"):
#		jump_was_pressed = true
#		jumpPressedTimer.start()
#		if can_jump==true:
#			motion.y = -JUMP_FORCE
#
#	motion.y += GRAVITY * delta * TARGET_FPS
#	if is_on_floor():
#		can_jump=true
#		if Input.is_action_just_pressed("ui_up"):
#			if jump_was_pressed==true:
#				motion.y = -JUMP_FORCE
#
#		if x_input == 0:
#			motion.x = lerp(motion.x, 0, FRICTION * delta)
#	else:
#		coyoteTimer.start()
#		#animationPlayer.play("Jump")
#		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
#			motion.y = -JUMP_FORCE/2
#
#		if x_input == 0:
#			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
#

#	if motion.y <80 and motion.y >-80:
#		if(Input.is_action_just_pressed("attack")) and can_fire == true:
#			attack_state()


#
#func _on_CoyoteTimer_timeout():
#	can_jump=false
#
#func _on_JumpPressedTimer_timeout():
#	jump_was_pressed = false

