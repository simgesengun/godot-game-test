extends KinematicBody2D

const TARGET_FPS = Engine.iterations_per_second
const GRAVITY = 8
const AIR_RESISTANCE = 1
const JUMP_FORCE = 242
const MAX_SPEED = 96
const ACCELERATION = 16
const FRICTION = 20
const SPI = 3.14
const HALF_SPI = 1.57

const Spell = preload("res://Spell.tscn")
var can_fire = true
var rate_of_fire = 0.1

var can_jump = true
var jump_was_pressed = false
var motion = Vector2.ZERO


var selected_skill

onready var sprite = $Sprite
onready var spriteWand = $Sprite/SpriteWand
onready var animationPlayer = $AnimationPlayer
onready var coyoteTimer = $CoyoteTimer
onready var jumpPressedTimer = $JumpPressedTimer
onready var wandPoint = $Sprite/SpriteWand/WandPoint

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	
	if x_input!=0:
		#animationPlayer.play("Run")
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
		#animationPlayer.play("Jump")
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
	
	motion = move_and_slide(motion,Vector2.UP)
	
	if(Input.is_action_just_pressed("attack")) and can_fire == true:
		attack_state()

func attack_state():
	can_fire = false
	
	spriteWand.rotation_degrees +=20
	var spell_instance = Spell.instance()
	spell_instance.skill_name = selected_skill
	spell_instance.position = wandPoint.get_global_position()
	spell_instance.global_rotation = spriteWand.global_rotation
	get_parent().add_child(spell_instance)
	
	yield(get_tree().create_timer(rate_of_fire),"timeout")
	can_fire = true

func _on_CoyoteTimer_timeout():
	can_jump=false

func _on_JumpPressedTimer_timeout():
	jump_was_pressed = false


func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
		mouse_pos = Vector2(int(mouse_pos.x), int(mouse_pos.y))
		spriteWand.look_at(mouse_pos)
		var pos = get_local_mouse_position()
		if pos.angle() > -HALF_SPI and pos.angle() < HALF_SPI:
			if sprite.scale.x < 0:
				sprite.scale.x *= -1
		else:
			if sprite.scale.x > 0:
				sprite.scale.x *= -1

		if (pos.angle()>0 and pos.angle()<HALF_SPI) or (pos.angle()>HALF_SPI and pos.angle()<SPI):
			if spriteWand.scale.y > 0:
				spriteWand.scale.y *= -1
			spriteWand.offset = Vector2(0,-5)
		else:
			if spriteWand.scale.y < 0:
				spriteWand.scale.y *= -1
			spriteWand.offset = Vector2(0,0)
