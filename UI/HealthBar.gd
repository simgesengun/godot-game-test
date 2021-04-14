extends Control

onready var health_under = $HealthUnder
onready var health_over = $HealthOver
onready var update_tween = $UpdateTween

var temp

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red

export (float,0,1,0.05) var caution_zone = 0.5
export (float,0,1,0.05) var danger_zone = 0.2

func _stats_ready(stats):
	health_over.max_value = stats.max_health
	health_under.max_value = stats.max_health
	health_over.value = stats.health
	health_under.value = stats.health

func _ready():
	temp = rect_position
	set_as_toplevel(true)

func _physics_process(_delta):
	rect_global_position = get_parent().global_position + temp

func _assign_color(health):
	if health < health_over.max_value * danger_zone:
		health_over.tint_progress = danger_color
	elif health < health_over.max_value * caution_zone:
		health_over.tint_progress = caution_color
	else:
		health_over.tint_progress = healthy_color

func _on_Stats_health_updated(health):
	health_over.value = health
	update_tween.interpolate_property(health_under,"value",health_under.value,health,Tween.TRANS_SINE, Tween.EASE_IN_OUT,0.2)
	update_tween.start()

	_assign_color(health)

func _on_Stats_no_health():
	health_over.value = 0
	update_tween.interpolate_property(health_under,"value",health_under.value,0,0.5,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()

	_assign_color(0)

func _on_Stats_max_health_updated(max_health):
	health_over.max_value = max_health
	health_under.max_value = max_health
