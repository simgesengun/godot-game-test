extends "res://Entities/StateMachine.gd"

var state_request
func _ready():
	call_deferred("set_state",Global.SE.NONE)

func _state_logic(delta):
	#Timed effects functions are here:
#	if [Global.SE.WATER, Global.SE.EARTH, Global.SE.MUD].has(state):
#		_slow_effect()
#	elif [Global.SE.FIRE, Global.SE.MAGMA].has(state):
#		_damage_effect()
#	elif state == Global.SE.ICE:
#		_immobilize_effect()
	pass

func _get_transition(delta):
	match state:
		Global.SE.NONE:
		#none -> fire
		#none -> earth
		#none -> water
		#none -> air
			if state_request!= null:
				return state_request
		Global.SE.FIRE:
		#fire + earth -> magma
		#fire + air -> burst
		#fire -> none
			if state_request == Global.SE.EARTH:
				return Global.SE.MAGMA
			elif state_request == Global.SE.AIR:
				return Global.SE.BURST
		Global.SE.WATER:
		#water + air  -> ice
		#water + earth -> mud
		#water -> none
			if state_request == Global.SE.AIR:
				return Global.SE.ICE
			elif state_request == Global.SE.EARTH:
				return Global.SE.MUD
		Global.SE.EARTH:
		#earth + fire -> magma
		#earth + water -> mud
		#earth -> none
			if state_request == Global.SE.FIRE:
				return Global.SE.MAGMA
			elif state_request == Global.SE.WATER:
				return Global.SE.MUD
		Global.SE.AIR:
			pass
		Global.SE.BURST:
			pass
		Global.SE.MAGMA:
			pass
		Global.SE.ICE:
			pass
		Global.SE.MUD:
			pass

func _enter_state(new_state, old_state):
	yield(get_tree().create_timer(0.1),"timeout")
	state_request = null
	parent.get_node("Label").text = Global.SE.keys()[new_state]
	match new_state:
		Global.SE.FIRE:
			_create_effect("Fire")
		Global.SE.WATER:
			_create_effect("Water")
		Global.SE.EARTH:
			_create_effect("Earth")
		Global.SE.AIR:
			_create_effect("Air")
		Global.SE.BURST:
			_create_effect("Burst")
		Global.SE.MAGMA:
			_create_effect("Magma")
		Global.SE.ICE:
			_create_effect("Ice")
		Global.SE.MUD:
			_create_effect("Mud")
	
func _exit_state(old_state, new_state):
	if old_state != Global.SE.NONE:
		parent.get_node("Effect").queue_free()


func _create_effect(effect_name):
	var effect = load("res://Entities/Skills/" + effect_name + "Effect.tscn")
	Global.instance_node(effect,parent.global_position-Vector2(0,7),parent)

func _effect_finished():
	set_state(Global.SE.NONE)


