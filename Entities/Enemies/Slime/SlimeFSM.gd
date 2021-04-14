extends "res://Entities/StateMachine.gd"

onready var animation_player = parent.get_node("AnimationPlayer")
export (NodePath) var stats_path
onready var stats = get_node(stats_path)

enum states{
	IDLE,
	FOLLOW,
	ATTACK,
	FROZEN,
	DEAD
}
func _ready():
	call_deferred("set_state",states.IDLE)
	stats.connect("no_health",self,"_no_health")
	stats.connect("immobilized",self,"_immobilized")

func _state_logic(delta):
	parent._apply_gravity()
	if ![states.ATTACK, states.FROZEN].has(state):
		parent._apply_movement(delta)
		parent._flip()
	if state == states.IDLE:
		parent._idle(delta)
	elif state == states.FOLLOW:
		parent._follow(delta)

func _get_transition(_delta):
	match state:
		states.IDLE:
			if parent._should_follow():
				return states.FOLLOW
				
		states.FOLLOW:
			if parent._should_attack():
				return states.ATTACK
			elif not parent._should_follow():
				return states.IDLE
		states.ATTACK:
			if not parent._should_attack():
				if parent._should_follow():
					return states.FOLLOW
				else:
					return states.IDLE
		states.FROZEN:
			if parent.stats.speed > 0:
				return states.IDLE
		states.DEAD:
			pass

func _enter_state(new_state, _old_state):
	#print(states.keys()[new_state])
	match new_state:
		states.IDLE:
			animation_player.play("Idle")
		states.FOLLOW:
			animation_player.play("Idle")
		states.ATTACK:
			animation_player.play("Attack")
		states.FROZEN:
			animation_player.play("Frozen")
		states.DEAD:
			animation_player.play("Death")
	
func _exit_state(_old_state, _new_state):
	pass

func _immobilized():
	set_state(states.FROZEN)

func _no_health():
	set_state(states.DEAD)

