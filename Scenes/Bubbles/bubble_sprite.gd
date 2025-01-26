extends AnimatedSprite2D

const BOB_SPEED = 0.1
var isUp = true
var offsetY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offsetY += -BOB_SPEED if isUp else BOB_SPEED
	offset = Vector2(0, offsetY)


func _on_timer_timeout():	 
	isUp = not isUp
	$Timer.start()
