extends Node

onready var start_point = $StartPoint

func _ready():
	Global.last_checkpoint = start_point.global_position

func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
