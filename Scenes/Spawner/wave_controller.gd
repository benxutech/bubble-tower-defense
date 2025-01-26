extends Path2D

var bubbleScenes := {
	"BaseBubble": preload("res://Scenes/Bubbles/BaseBubble.tscn"),
	"YellowBubble": preload("res://Scenes/Bubbles/Variants/YellowBubble.tscn"),
	"RedBubble": preload("res://Scenes/Bubbles/Variants/RedBubble.tscn"),
	"PurpleBubble": preload("res://Scenes/Bubbles/Variants/PurpleBubble.tscn"),
	"PinkBubble": preload("res://Scenes/Bubbles/Variants/PinkBubble.tscn")
}
var waves_data = {}
var current_wave_bubbles = []
var current_wave = 0

func _ready() -> void:
	GlobalSignal.change_spawner_status.connect(_on_change_spawner_status)
	var file = FileAccess.open("res://data/waves.json", FileAccess.READ)
	if file:
		var json = file.get_as_text()
		waves_data = JSON.parse_string(json)["waves"]
		file.close()

# adds an array of bubbles to the current_wave_bubbles variable, once this array is empty and no bubbles remain we go next wave
func start_new_wave() -> void:
	current_wave += 1
	
	GlobalSignal.wave_update.emit(current_wave)
	var current_wave_data = waves_data[current_wave - 1]
	if current_wave_data:
		for bubble_info in current_wave_data["bubbles"]:
			add_bubbles_to_wave(bubble_info)
		if $SpawnTimer:
			$SpawnTimer.wait_time = 0.5 * current_wave_data.spawn_interval
			print($SpawnTimer.wait_time)
		
func add_bubbles_to_wave(bubble_info: Dictionary) -> void:
	var bubble_type = bubble_info["type"]
	var bubble_count = bubble_info["count"]
	
	for i in range(bubble_count):
		current_wave_bubbles.append(bubble_type)

func _process(_delta: float) -> void:
	pass

func _on_change_spawner_status(is_active: bool) -> void:
	if is_active:
		$SpawnTimer.start()
	else:
		$SpawnTimer.stop()

func _on_spawn_timer_timeout() -> void:
	if current_wave_bubbles.size() == 0:
		var max_waves = waves_data.size()
		if max_waves <= current_wave:
			print('game over')
		else:
			start_new_wave()
	else: 
		var bubble_to_spawn = current_wave_bubbles[0]
		var bubble_scene = bubbleScenes[bubble_to_spawn]
		var bubble_instance = bubble_scene.instantiate()
		
		add_child(bubble_instance)
		current_wave_bubbles.pop_front()
