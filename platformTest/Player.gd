extends KinematicBody2D

const TARGET_FPS = Engine.iterations_per_second
const GRAVITY = 8
const AIR_RESISTANCE = 1
const JUMP_FORCE = 196
const MAX_SPEED = 96
const ACCELERATION = 16
const FRICTION = 20
const SPI = 3.14
const HALF_SPI = 1.57

const FireSpell = preload("res://FireSpell.tscn")
const WaterSpell = preload("res://WaterSpell.tscn")

var can_jump = true
var jump_was_pressed = false
var motion = Vector2.ZERO

var fire = false
var water = false

onready var sprite = $Sprite
onready var spriteWand = $Sprite/SpriteWand
onready var animationPlayer = $AnimationPlayer
onready var coyoteTimer = $CoyoteTimer
onready var jumpPressedTimer = $JumpPressedTimer
onready var wandPoint = $Sprite/SpriteWand/WandPoint

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	
	if x_input!=0:
		animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	else:
		animationPlayer.play("Idle")
	
	if Input.is_action_just_pressed("ui_up"):
		jump_was_pressed = true
		jumpPressedTimer.start()
		if can_jump==true:
			motion.y = -JUMP_FORCE
	
	motion.y += GRAVITY * delta * TARGET_FPS
	if is_on_floor():
		can_jump=true
		if Input.is_action_just_pressed("ui_up"):
			if jump_was_pressed==true:
				motion.y = -JUMP_FORCE
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
	else:
		coyoteTimer.start()
		animationPlayer.play("Jump")
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
	
	motion = move_and_slide(motion,Vector2.UP)
	
	spells()
	if Input.is_action_just_pressed("attack"):
		attack_state()

func spells():
	if Input.is_action_just_pressed("attack_skill"):
		fire = !fire
	if Input.is_action_just_pressed("attack_skill_2"):
		water = !water

func attack_state():
	spriteWand.rotation_degrees +=20
	if isFireWater():
		print("both")
		fire = false
		water = false
	elif isFire():
		var s = FireSpell.instance()
		get_parent().add_child(s)
		s.position = wandPoint.global_position
		s.global_rotation = spriteWand.global_rotation
		fire = false
	elif isWater():
		var s = WaterSpell.instance()
		get_parent().add_child(s)
		s.position = wandPoint.global_position
		s.global_rotation = spriteWand.global_rotation
		water = false

func _on_CoyoteTimer_timeout():
	can_jump=false

func _on_JumpPressedTimer_timeout():
	jump_was_pressed = false
	
func isFire():
	if fire == true:
		return true

func isWater():
	if water == true:
		return true

func isFireWater():
	if isWater() && isFire():
		return true

func _input(event):
	if event is InputEventMouseMotion:
		spriteWand.look_at(get_global_mouse_position())
		var pos = get_local_mouse_position()
		if pos.angle() > -HALF_SPI and pos.angle() < HALF_SPI:
			if sprite.scale.x < 0:
				sprite.scale.x *= -1
		else:
			if sprite.scale.x > 0:
				sprite.scale.x *= -1

		if (pos.angle()>0 and pos.angle()<HALF_SPI) or (pos.angle()>HALF_SPI and pos.angle()<SPI):
				spriteWand.flip_v = true
				spriteWand.offset = Vector2(0,-4)
		else:
				spriteWand.flip_v = false
				spriteWand.offset = Vector2(0,0)
