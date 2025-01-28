extends Node2D

@export var health = 1
@export var candy = 0
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
	GlobalSignal.view_tower_data.connect(set_tower_view_data)
	health_label = $HpPanel/HSplitContainer/HealthLabel
	candy_label = $PanelContainer/VBoxContainer/HSplitContainer/CandyNumber
	wave_label = $PanelContainer/HSplitContainer/WaveNumber

func render_tower_create_ui():
	$CreateTowerUI.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if $CreateTowerUI.visible:
		$CreateTowerUI.position = get_viewport().get_mouse_position()
	
func reset_tower_create_ui():
	$CreateTowerUI.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func set_tower_view_data(tower):
	print("clicked the tower")
	print(tower.collision_radius)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if health_label:
		health_label.text = str(health)
	if candy_label:
		candy_label.text = str(candy)
	if wave_label:
		wave_label.text = str(wave_number)
	
	if current_selected_tower > 0:
		render_tower_create_ui()
	else:
		reset_tower_create_ui()

func _input(event) -> void:
	if event is InputEventMouseButton && current_selected_tower > 0:
		if event.pressed:
#			refactor to tower cost
			if candy > 10:
				candy -= 10
				place_tower(event.position)
				current_selected_tower = -1

func place_tower(position: Vector2) -> void:
	var towerScene = preload("res://Scenes/Towers/Variants/PokeTower.tscn")
	var tower = towerScene.instantiate()

	self.add_child(tower)
	tower.position = position
	tower.place()

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


func _on_button_1_pressed() -> void:
	current_selected_tower *= -1
