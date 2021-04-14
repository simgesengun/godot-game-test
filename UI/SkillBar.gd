extends Control

onready var inactive_icon = load("res://UI/ui_skill_inactive.png")
onready var active_icon = load("res://UI/ui_skill_active.png")

onready var shortcuts = get_tree().get_nodes_in_group("shortcuts")
onready var loaded_skills = {"Shortcut1":"Fire","Shortcut2":"Water", "Shortcut3":"Earth","Shortcut4":"Air"}

func _ready():
	LoadShortcuts()
	SelectShortcut(shortcuts[0])
	
func _input(event):
	if Input.is_action_just_pressed("Skill"):
		match event.scancode:
			KEY_1:
				SelectShortcut(shortcuts[0])
			KEY_2:
				SelectShortcut(shortcuts[1])
			KEY_3:
				SelectShortcut(shortcuts[2])
			KEY_4:
				SelectShortcut(shortcuts[3])
	
func LoadShortcuts():
	for shortcut in shortcuts:
		shortcut.get_node("TextureButton").connect("pressed",self,"SelectShortcut", [shortcut])
		var skill_icon = load("res://UI/ui_skill_" + loaded_skills[shortcut.name] + ".png")
		shortcut.get_node("TextureButton").set_normal_texture(skill_icon)

func SelectShortcut(shortcut):
	CleanShortcuts()
	shortcut.texture = active_icon
	Events.emit_signal("skill_selected",loaded_skills[shortcut.name])

func CleanShortcuts():
	for shortcut in shortcuts:
		shortcut.texture = inactive_icon

func _on_Stats_no_health():
	CleanShortcuts()
