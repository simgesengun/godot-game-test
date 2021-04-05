extends "res://Entities/StateMachine.gd"

enum states{
	IDLE,
	WALK,
	FOLLOW,
	ATTACK,
	FROZEN,
	DEAD
}
func _ready():
	call_deferred("set_state",states.IDLE)

func _state_logic(delta):
	parent._apply_gravity()
	parent._flip()
	if state == states.IDLE:
		parent._idle(delta)
	elif state == states.WALK:
		parent._walk(delta)
	elif state == states.FOLLOW:
		parent._follow(delta)
	elif state == states.ATTACK:
		parent._attack()

func _get_transition(delta):
	match state:
		states.IDLE:
			if parent._should_follow():
				return states.FOLLOW
		states.WALK:
			if parent._should_follow():
				return states.FOLLOW
		states.FOLLOW:
			if parent._should_attack():
				return states.ATTACK
			elif not parent._should_follow():
				return states.IDLE
		states.ATTACK:
			if not parent._should_attack():
				return states.IDLE
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
#		states.WALK:
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

func _on_Stats_immobilized():
	set_state(states.FROZEN)

func _on_Stats_no_health():
	set_state(states.DEAD)

func pick_random_state():
	var random = randi()%2
	print(random)
	if random == 0:
		set_state(states.IDLE)
	else:
		set_state(states.WALK)
