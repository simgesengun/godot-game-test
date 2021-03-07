extends KinematicBody2D

var speed=50
var velocity = Vector2()
export var direction =-1

onready var animationPlayer = self.get_node("AnimationPlayer")


func _ready():
	animationPlayer.play("idle")
	if direction==1:
		$Sprite.flip_h=true
func _physics_process(delta):
	if is_on_wall():
		direction = direction * -1
		$Sprite.flip_h = not $Sprite.flip_h
	
	velocity.y += 20
	
	velocity.x = speed*direction
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_area_check_body_entered(body):
	speed=0
	animationPlayer.play("Attack")
	
	

func _on_top_checker_body_entered(body):
	animationPlayer.play("Dead")
	speed=0
	$Timer.start()


func _on_Timer_timeout():
	queue_free()


func _on_area_check_body_exited(body):
	animationPlayer.play("idle")
	speed=50
