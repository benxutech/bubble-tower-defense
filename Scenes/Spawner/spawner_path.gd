extends PathFollow2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.change_spawner_status.connect(_on_change_spawner_status)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_change_spawner_status(is_active: bool) -> void:
	if is_active:
		$SpawnTimer.start()
	else:
		$SpawnTimer.stop()

func _on_spawn_timer_timeout() -> void:
	var bubbleScene := preload("res://Scenes/Bubbles/BaseBubble.tscn")
	var bubble = bubbleScene.instantiate()
	
	get_parent().add_child(bubble)
