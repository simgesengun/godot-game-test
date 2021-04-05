extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight
var root
func _ready():
	root = get_tree().get_root()
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x

func _process(_delta):
	root.canvas_transform.origin = Vector2(round(root.canvas_transform.origin.x), round(root.canvas_transform.origin.y))
