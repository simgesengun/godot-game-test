extends "res://Entities/StateMachine.gd"

enum states{
	IDLE,
	WALK,
	FOLLOW,
	ATTACK,
	FROZEN,
	DEAD
}

export (NodePath) var stats_path
onready var stats = get_node(stats_path)
export (NodePath) var timer_path
onready var timer = get_node(timer_path)

func _ready():
	call_deferred("set_state",states.IDLE)
	stats.connect("no_health",self,"_no_health")
	stats.connect("immobilized",self,"_immobilized")

func _state_logic(delta):
	parent._apply_gravity()
	if ![states.ATTACK,states.FROZEN].has(state):
		parent._flip()
		parent._apply_movement(delta)
	if state == states.IDLE:
		parent._idle(delta)
	elif state == states.WALK:
		parent._walk(delta)
	elif state == states.FOLLOW:
		parent._follow(delta)

func _get_transition(delta):
	match state:
		states.IDLE:
			if parent._should_follow():
				return states.FOLLOW
			elif timer.time_left == 0:
				pick_random_state()
		states.WALK:
			if parent._should_follow():
				return states.FOLLOW
			elif timer.time_left == 0:
				pick_random_state()
		states.FOLLOW:
			if parent._should_attack():
				return states.ATTACK
			elif not parent._should_follow():
				return states.IDLE
		states.ATTACK:
			if not parent._should_attack():
				pick_random_state()
		states.FROZEN:
			if parent.stats.speed > 0:
				return states.IDLE
		states.DEAD:
			pass

func _enter_state(new_state, old_state):
	print(states.keys()[new_state])
	match new_state:
#		states.IDLE:
#			animated_sprite.play("idle")
		states.WALK:
			parent._pick_direction()
#			animated_sprite.play("walk")
#		states.FOLLOW:
#			animated_sprite.play("walk")
#		states.ATTACK:
#			animated_sprite.play("idle")
#		states.FROZEN:
#			animated_sprite.play("idle")
		states.DEAD:
			yield(get_tree().create_timer(.5), "timeout")
			parent.queue_free()

func _exit_state(old_state, new_state):
	pass


func _immobilized():
	set_state(states.FROZEN)

func _no_health():
	set_state(states.DEAD)

func pick_random_state():
	var random = randi()%2
	if random == 0:
		set_state(states.IDLE)
	else:
		set_state(states.WALK)
	timer.start(rand_range(3,5))
