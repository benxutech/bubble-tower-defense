extends PathFollow2D

class_name SimpleBubble

var health = 1
var speed = 0.2
var is_destroyed := false
var base_damage = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass

func finished_path():
	if is_destroyed:
		return
	is_destroyed = true
	GlobalSignal.damage_taken.emit(base_damage)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	progress_ratio += speed * delta
	
	if progress_ratio >= 1:
		finished_path()
		return

# Destroys the bubble
func pop() -> void:
	queue_free()
