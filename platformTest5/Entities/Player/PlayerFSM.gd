extends "res://Entities/StateMachine.gd"

enum states{
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	CRAWL
}
func _ready():
	call_deferred("set_state",states.IDLE)

func _state_logic(delta):
	if [states.IDLE, states.RUN,states.JUMP,states.FALL].has(state):
		parent._handle_movement()
	elif [states.CRAWL, states.CROUCH].has(state):
		parent._handle_movement(parent.CRAWL_SPEED)
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(delta):
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
			elif parent.motion.x ==0:
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

func _enter_state(new_state, old_state):
	match new_state:
		states.IDLE:
			parent.label.text = "IDLE"
			parent.animationPlayer.play("Idle")
		states.RUN:
			parent.label.text = "RUN"
		states.JUMP:
			parent.label.text = "JUMP"
		states.FALL:
			parent.label.text = "FALL"
		states.CROUCH:
			parent.label.text = "CROUCH"
			if old_state!=states.CRAWL:
				parent._on_crouch()
		states.CRAWL:
			parent.label.text = "CRAWL"
			if old_state!=states.CROUCH:
				parent._on_crouch()
	
func _exit_state(old_state, new_state):
	match old_state:
		states.CROUCH:
			if new_state!=states.CRAWL:
				parent._on_stand()
		states.CRAWL:
			if new_state != states.CROUCH:
				parent._on_stand()

func _input(event):
	if [states.IDLE, states.RUN].has(state):
		#jump
		if event.is_action_pressed("ui_up"):
			parent._jump()
	
	if state==states.JUMP:
	#variable jump
		if event.is_action_released("ui_up") && parent.motion.y < -parent.JUMP_FORCE/2:
			parent.motion.y = -parent.JUMP_FORCE/2
		
	if event is InputEventMouseMotion:
		parent._handle_direction()
	
	if ![states.CROUCH, states.CRAWL].has(state):
		if parent.motion.y <80 and parent.motion.y >-80:
			if event.is_action_pressed("attack") && parent.can_fire:
				parent._attack()
	

func is_crouching():
	return [states.CROUCH,states.CRAWL].has(state)
