extends Control

onready var health_under = $HealthUnder
onready var health_over = $HealthOver
onready var update_tween = $UpdateTween

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red

export (float,0,1,0.05) var caution_zone = 0.5
export (float,0,1,0.05) var danger_zone = 0.2

func _ready():
	PlayerEvents.connect("health_updated",self,"_health_updated")
	PlayerEvents.connect("no_health",self,"_no_health")
	PlayerEvents.connect("max_health_updated",self,"_max_health_updated")
	Events.emit_signal("health_bar_ready")
	
func _assign_color(health):
	if health < health_over.max_value * danger_zone:
		health_over.tint_progress = danger_color
	elif health < health_over.max_value * caution_zone:
		health_over.tint_progress = caution_color
	else:
		health_over.tint_progress = healthy_color

func _health_updated(health):
	health_over.value = health
	update_tween.interpolate_property(health_under,"value",health_under.value,health,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()

	_assign_color(health)

func _no_health():
	health_over.value = 0
	update_tween.interpolate_property(health_under,"value",health_under.value,0,0.5,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()

	_assign_color(0)

func _max_health_updated(max_health):
	health_over.max_value = max_health
	health_under.max_value = max_health

