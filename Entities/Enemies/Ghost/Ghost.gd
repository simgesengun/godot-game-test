extends KinematicBody2D

var speed = 50
var velocity = Vector2()
var direction:int = -1
var friction = 200
export var acceleration = 300
onready var animationPlayer = self.get_node("AnimationPlayer")
onready var playerDetectionZone = $PlayerDetectionZone
onready var hitBox = $Hitbox
onready var sprite = $Sprite
onready var controller = $Controller

enum{
	IDLE
}
var state = IDLE

func _ready():
	state = IDLE
	
func _physics_process(delta):
	sprite.flip_h =velocity.x<0

	match state:
		IDLE:
			if is_on_wall():
				direction = direction * -1
			animationPlayer.play("walk")
			if controller.get_time_left() == 0:
				state = pick_random_state([IDLE])
				controller.start_timer(rand_range(1,3))
			velocity.x = speed*direction
			velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
			
	velocity = move_and_slide(velocity,Vector2.UP)

	
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	

