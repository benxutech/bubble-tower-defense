extends PathFollow2D

class_name BaseBubble

var health = 1
var speed = 0.1
var is_destroyed := false
var base_damage = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BubbleSprite.modulate = Color.YELLOW

func finished_path():
	if is_destroyed:
		return
	is_destroyed = true
	GlobalSignal.damage_taken.emit(base_damage)
	pop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += speed * delta
	
	if progress_ratio >= 1:
		finished_path()
		return

# Destroys the bubble
func pop() -> void:
	speed = 0
	is_destroyed = true
	$BubbleSprite.play("pop")

func _on_animated_sprite_2d_animation_finished():
	if is_destroyed:
		queue_free()


func _on_area_2d_input_event(viewport, event, shape_idx):
	pop()
