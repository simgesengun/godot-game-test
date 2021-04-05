extends "res://Entities/StateMachine.gd"

onready var animation_player = parent.get_node("AnimationPlayer")

enum states{
	IDLE,
	FOLLOW,
	ATTACK,
	FROZEN,
	DEAD
}
func _ready():
	call_deferred("set_state",states.IDLE)

func _state_logic(delta):
	parent._apply_gravity()
	parent._apply_movement()
	parent._flip()
	if state == states.IDLE:
		parent._idle(delta)
	elif state == states.FOLLOW:
		parent._follow(delta)

func _get_transition(delta):
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

func _enter_state(new_state, old_state):
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
	
func _exit_state(old_state, new_state):
	pass

func _on_Stats_immobilized():
	set_state(states.FROZEN)

func _on_Stats_no_health():
	set_state(states.DEAD)


func _on_HurtBox_area_entered(area):
	area.get_parent().bounce(200)
	set_state(states.DEAD)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		parent.queue_free()
