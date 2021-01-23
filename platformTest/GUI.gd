extends CanvasLayer

onready var shortcuts_path = 'SkillBar/Background/HBoxContainer/'

var loaded_skills = {"Shortcut1":"Fire","Shortcut2":"Water"}
var skill_keys = {"1":"Shortcut1","2":"Shortcut2", "3":"Shortcut3","4":"Shortcut4"}

func _ready():
	LoadShortcuts()
	for shortcut in get_tree().get_nodes_in_group("Shortcuts"):
		shortcut.connect("pressed",self,"SelectShortcut", [shortcut.get_parent().get_name()])
	SelectShortcut("Shortcut1")
	
func _input(event):
	if(Input.is_action_just_pressed("Skill")):
		SelectShortcut(skill_keys[event.as_text()])
	
func LoadShortcuts():
	for shortcut in loaded_skills.keys():
		var skill_icon = load("res://Sprites/ui_skill_" + loaded_skills[shortcut] + ".png")
		get_node(shortcuts_path + shortcut + "/TextureButton").set_normal_texture(skill_icon)
		
func SelectShortcut(shortcut):
	CleanShortcuts()
	var active_icon = load("res://Sprites/ui_skill_active.png")
	get_node(shortcuts_path + shortcut).texture = active_icon
	get_parent().get_node("Player").selected_skill = loaded_skills[shortcut]
		
func CleanShortcuts():
	var inactive_icon = load("res://Sprites/ui_skill_inactive.png")
	for shortcut in loaded_skills.keys():
		get_node(shortcuts_path + shortcut).texture = inactive_icon

