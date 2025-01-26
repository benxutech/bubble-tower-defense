extends Path2D

var bubbleScenes:= [
	preload("res://Scenes/Bubbles/BaseBubble.tscn"),
	preload("res://Scenes/Bubbles/YellowBubble.tscn"),
	preload("res://Scenes/Bubbles/PurpleBubble.tscn"),
	preload("res://Scenes/Bubbles/RedBubble.tscn"),
	preload("res://Scenes/Bubbles/PinkBubble.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.change_spawner_status.connect(_on_change_spawner_status)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_change_spawner_status(is_active: bool) -> void:
	if is_active:
		$SpawnTimer.start()
	else:
		$SpawnTimer.stop()

func _on_spawn_timer_timeout() -> void:
	var random_index = randi() % bubbleScenes.size()
	var random_bubble_scene = bubbleScenes[random_index]
	
	var bubble = random_bubble_scene.instantiate()

	add_child(bubble)
