extends AnimatedSprite2D

const BOB_SPEED = 0.1
var isUp = true
var offsetY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isUp:
		offsetY -= BOB_SPEED
	else:
		offsetY += BOB_SPEED
	offset = Vector2(0, offsetY)


func _on_timer_timeout():	 
	if isUp:
		isUp = false
	else:
		isUp = true
	$Timer.start()
