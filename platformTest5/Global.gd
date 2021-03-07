extends Node

var Player :KinematicBody2D

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

func register_player(in_player):
	Player = in_player

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance


func instance_node_deferred(node, location, parent):
	var node_instance = node.instance()
	parent.call_deferred("add_child",node_instance)
	node_instance.global_position = location
	return node_instance
