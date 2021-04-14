extends "res://Entities/StateMachine.gd"

onready var animation_player:AnimationPlayer = parent.get_node("AnimationPlayer")
onready var anim_tree:AnimationTree = parent.get_node("AnimationTree")
onready var anim_state_machine = anim_tree["parameters/playback"]

enum states{
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	CRAWL,
	DAMAGED,
	DEAD
}
func _ready():
	call_deferred("set_state",states.IDLE)
	PlayerEvents.connect("no_health",self,"_no_health")
	PlayerEvents.connect("health_updated",self,"_health_updated")

func _state_logic(_delta):
	if [states.IDLE, states.RUN,states.JUMP,states.FALL,states.DAMAGED].has(state):
		parent._handle_mouse_direction()
		parent._handle_movement()
	elif [states.CRAWL, states.CROUCH].has(state):
		parent._handle_direction()
		parent._handle_movement(parent.CRAWL_SPEED)
	parent._apply_gravity()
	parent._apply_movement()
	parent._flip()

func _get_transition(_delta):
	match state:
		states.IDLE:
			if !parent.check_is_grounded():
				if parent.motion.y<0:
					return states.JUMP
				else:
					return states.FALL
			elif parent.motion.x!=0:
				return states.RUN
			elif Input.is_action_pressed("ui_down"):
				return states.CROUCH
		states.RUN:
			if !parent.check_is_grounded():
				if parent.motion.y<0:
					return states.JUMP
				else:
					return states.FALL
			elif parent.motion.x == 0:
				return states.IDLE
			elif Input.is_action_pressed("ui_down"):
				return states.CRAWL
		states.JUMP:
			if parent.check_is_grounded():
				return states.IDLE
			elif parent.motion.y >= 0:
				return states.FALL
		states.FALL:
			if parent.check_is_grounded():
				return states.IDLE
			elif parent.motion.y <0:
				return states.JUMP
		states.CROUCH:
			if !Input.is_action_pressed("ui_down") && parent.can_stand():
				return states.IDLE
			elif !parent.is_on_floor():
				return states.FALL
			elif parent.motion.x !=0:
				return states.CRAWL
		states.CRAWL:
			if !Input.is_action_pressed("ui_down") && parent.can_stand():
				return states.RUN
			elif !parent.is_on_floor():
				return states.FALL
			elif parent.motion.x ==0:
				return states.CROUCH
		states.DAMAGED:
			pass
		states.DEAD:
			pass

func _enter_state(new_state, old_state):
	parent.label.text = states.keys()[new_state]
	
	if [states.IDLE,states.RUN,states.JUMP,states.FALL].has(new_state):
		parent._enable_arm()
	else:
		parent._disable_arm()
	
	match new_state:
		states.IDLE:
			anim_state_machine.travel("Idle")
		states.RUN:
			anim_state_machine.travel("Run")
		states.JUMP:
			anim_state_machine.travel("Jump")
		states.FALL:
			anim_state_machine.travel("Fall")
		states.CROUCH:
			anim_state_machine.travel("Crouch")
			if old_state!=states.CRAWL:
				parent._on_crouch()
		states.CRAWL:
			anim_state_machine.travel("Crawl")
			if old_state!=states.CROUCH:
				parent._on_crouch()
		states.DAMAGED:
			anim_tree["parameters/conditions/damaged"] = true
		states.DEAD:
			anim_tree["parameters/conditions/death"] = true
			Global.disable_hurtbox(parent,true)
	
func _exit_state(old_state, new_state):
	match old_state:
		states.CROUCH:
			if new_state!=states.CRAWL:
				parent._on_stand()
		states.CRAWL:
			if new_state != states.CROUCH:
				parent._on_stand()
		states.DAMAGED:
			anim_tree["parameters/conditions/damaged"] = false

			
func _input(event):
	if [states.IDLE, states.RUN, states.DAMAGED].has(state):
		#jump
		if event.is_action_pressed("ui_up"):
			parent._jump()
	
	if [states.JUMP].has(state):
	#variable jump
		if event.is_action_released("ui_up") && parent.motion.y < -parent.JUMP_FORCE/2:
			parent.motion.y = -parent.JUMP_FORCE/2
	
	if !is_crouching():
		if parent.motion.y <80 and parent.motion.y >-80:
			if event.is_action_pressed("attack") && parent.can_fire:
				parent._attack()

func is_crouching():
	return [states.CROUCH,states.CRAWL].has(state)

func _health_updated(_health):
	set_state(states.DAMAGED)

func _no_health():
	set_state(states.DEAD)

func _anim_damaged_finished():
	set_state(states.IDLE)

func _anim_death_finished():
	Global.reset()

