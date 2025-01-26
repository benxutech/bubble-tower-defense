extends Node2D

var health = 3
var is_game_over = false
var health_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.damage_taken.connect(on_damage_taken)
	GlobalSignal.change_spawner_status.emit(true)
	health_label = get_node("VBoxContainer/HealthLabel")

func _input(event: InputEvent) -> void:
	# TODO: remove false
	if false && event is InputEventMouseButton:
		if event.is_pressed():
			place_tower(event.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if health_label:
		health_label.text = str(health)
	
func place_tower(position: Vector2) -> void:
	var towerScene := preload("res://Scenes/Towers/BaseTower.tscn")
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

func finish_map() -> void:
	GlobalSignal.change_spawner_status.emit(false)
