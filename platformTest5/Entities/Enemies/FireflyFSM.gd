extends "res://Entities/StateMachine.gd"

var state_request
func _ready():
	call_deferred("set_state",Global.SE.NONE)

func _state_logic(delta):
	pass

func _get_transition(delta):
	match state:
		Global.SE.NONE:
		#none -> water
			if state_request!= null:
				return state_request                                                                                                      
		Global.SE.WATER:
			pass

func _enter_state(new_state, old_state):
	state_request = null  
	yield(get_tree().create_timer(0.1),"timeout")
	match new_state:
		Global.SE.WATER:
			_create_effect("Water")
	
func _exit_state(old_state, new_state):
	if old_state != Global.SE.NONE:
		parent.get_node("Effect").queue_free()
  

func _create_effect(effect_name):
	var effect = load("res://Entities/Skills/Effects/" + effect_name + "Effect.tscn")
	Global.instance_node(effect,parent.global_position-Vector2(0,7),parent)

func _effect_finished():
	set_state(Global.SE.NONE)                                                        


