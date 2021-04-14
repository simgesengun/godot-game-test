extends Node

var Player :KinematicBody2D
var last_checkpoint


onready var player = load("res://Entities/Player/Player.tscn")

enum SE{
	NONE,
	FIRE,
	WATER,
	EARTH,
	AIR,
	BURST,
	MAGMA,
	ICE,
	MUD
}

func change_scene(new_scene, player_pos):
	get_tree().change_scene(new_scene)
	Player.set_position(player_pos)

func reset():
	Player.queue_free()
	yield(get_tree().create_timer(5),"timeout")
	instance_node(player,last_checkpoint,get_tree().get_current_scene())
	get_tree().call_group("enemies","respawn")


func disable_hurtbox(parent,boolean):
	var hurtboxes = Utils.findNodeDescendantsInGroup(parent, "Hurtbox")
	for hurtbox in hurtboxes:
		hurtbox.get_node("CollisionShape2D").disabled = boolean

func respawn(parent):
	disable_hurtbox(parent,true)
	parent.get_node("EffectsAnimation").play("Respawn")
	yield(get_tree().create_timer(0.8),"timeout")
	disable_hurtbox(parent,false)

func register_player(in_player):
	Player = in_player

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
	
func instance_node_rotated(node, location, parent,rotation):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	node_instance.rotation_degrees = rotation
	return node_instance


func instance_node_deferred(node, location, parent):
	var node_instance = node.instance()
	parent.call_deferred("add_child",node_instance)
	node_instance.global_position = location
	return node_instance

