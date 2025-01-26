extends Node2D

var health = 3
var candy = 0
var wave_number = 1
var is_game_over = false
var health_label
var current_selected_tower = -1
var candy_label
var wave_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.damage_taken.connect(on_damage_taken)
	GlobalSignal.bubble_popped.connect(on_bubble_popped)
	GlobalSignal.wave_update.connect(on_wave_update)
	GlobalSignal.change_spawner_status.emit(true)
	health_label = $HpPanel/HSplitContainer/HealthLabel
	candy_label = $PanelContainer/VBoxContainer/HSplitContainer/CandyNumber
	wave_label = $PanelContainer/HSplitContainer/WaveNumber
	#place_tower(Vector2(100, 350))
	#place_tower(Vector2(50, 350))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if health_label:
		health_label.text = str(health)
	if candy_label:
		candy_label.text = str(candy)
	if wave_label:
		wave_label.text = str(wave_number)
		
		
#func _input(event) -> void:
	#if event is InputEventMouseButton:
		#if event.pressed:
			##check if afford
			##deduct money
			#place_tower(event.position)
			#current_selected_tower = -1
		
		
func place_tower(position: Vector2) -> void:
	var towerScene := preload("res://Scenes/Towers/Variants/PokeTower.tscn")
	var tower = towerScene.instantiate()

	tower.position = position
	tower.place()
	add_child(tower)


func on_damage_taken(damage_point: int) -> void:
	if is_game_over:
		return
	
	health -= damage_point
	## maybe we want to emit an event here?
	
	if health <= 0:
		finish_map()
		is_game_over = true
		
func on_bubble_popped(bubble_max_health: int) -> void:
	candy += bubble_max_health

func on_wave_update(wave: int) -> void:
	wave_number = wave

func finish_map() -> void:
	GlobalSignal.change_spawner_status.emit(false)


func _on_button_1_pressed():
	current_selected_tower = 1


func _on_button_2_pressed():
	current_selected_tower = 2


func _on_button_3_pressed():
	current_selected_tower = 3
