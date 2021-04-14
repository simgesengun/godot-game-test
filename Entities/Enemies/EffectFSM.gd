extends "res://Entities/StateMachine.gd"

onready var collision_shape = parent.get_node("CollisionShape2D")
var state_request
func _ready():
	call_deferred("set_state",Global.SE.NONE)

func _state_logic(_delta):
	#Timed effects functions are here:
#	if [Global.SE.WATER, Global.SE.EARTH, Global.SE.MUD].has(state):
#		_slow_effect()
#	elif [Global.SE.FIRE, Global.SE.MAGMA].has(state):
#		_damage_effect()
#	elif state == Global.SE.ICE:
#		_immobilize_effect()
	pass

func _get_transition(_delta):
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
		#fire + water -> none
		#fire -> none
			if state_request == Global.SE.EARTH:
				return Global.SE.MAGMA
			elif state_request == Global.SE.AIR:
				return Global.SE.BURST  
			elif state_request == Global.SE.WATER:
				return Global.SE.NONE                                                                                                      
		Global.SE.WATER:
		#water + air  -> ice
		#water + earth -> mud
		#water + fire -> none
		#water -> none
			if state_request == Global.SE.AIR:
				return Global.SE.ICE
			elif state_request == Global.SE.EARTH:
				return Global.SE.MUD
			elif state_request == Global.SE.FIRE:
				return Global.SE.NONE
		Global.SE.EARTH:
		#earth + fire -> magma
		#earth + water -> mud
		#earth + air -> air
		#earth -> none
			if state_request == Global.SE.FIRE:
				return Global.SE.MAGMA
			elif state_request == Global.SE.WATER:
				return Global.SE.MUD
			elif state_request == Global.SE.AIR:
				return Global.SE.AIR
		Global.SE.MAGMA:
		#magma + water -> none
		#magma + air -> air
			if state_request == Global.SE.WATER:
				return Global.SE.NONE
			elif state_request == Global.SE.AIR:
				return Global.SE.AIR
		Global.SE.MUD:
		#mud + fire -> none
		#mud + air -> air
			if state_request == Global.SE.FIRE:
				return Global.SE.NONE
			elif state_request == Global.SE.AIR:
				return Global.SE.AIR
		Global.SE.ICE:
		#ice + fire -> none
		#ice + earth -> earth
			if state_request == Global.SE.FIRE:
				return Global.SE.NONE
			elif state_request == Global.SE.EARTH:
				return Global.SE.EARTH
		Global.SE.AIR:
			pass
		Global.SE.BURST:
			pass

func _enter_state(new_state, _old_state):
	state_request = null  
	yield(get_tree().create_timer(0.1),"timeout")
	#parent.get_node("Label").text = Global.SE.keys()[new_state]
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
	
func _exit_state(old_state, _new_state):
	if old_state != Global.SE.NONE:
		parent.get_node("Effect").queue_free()
	match old_state:
		Global.SE.FIRE:
			parent.get_node("Burning").queue_free()
  

func _create_effect(effect_name):
	var effect = load("res://Entities/Skills/Effects/" + effect_name + "Effect.tscn")
	var offset = Vector2(0,collision_shape.shape.extents.y)
	if [Global.SE.MUD, Global.SE.WATER].has(state):
		Global.instance_node(effect,parent.global_position - offset,parent)
	else:
		Global.instance_node(effect,parent.global_position + offset,parent)
		

func _effect_finished():
	set_state(Global.SE.NONE)                                                        


