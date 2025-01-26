extends Node2D

@export var damage = 1
@export var speed = 2
@export var lifetime = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	translate(Vector2(-speed, 0).rotated(rotation))
	#translate(Vector2())


func _on_area_2d_area_entered(area):
	if area is BaseBubble:
		print(area)
		queue_free()
