extends Node2D

var health = 3
var is_game_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.damage_taken.connect(on_damage_taken)
	$SpawnerPath/SpawnTimer.start()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			var towerScene := preload("res://Scenes/Towers/BaseTower.tscn")
			var tower = towerScene.instantiate()
			
			tower.position = event.position
			add_child(tower)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_damage_taken(damage_point: int) -> void:
	if is_game_over:
		return
	
	health -= damage_point
	## maybe we want to emit an event here?
	
	if health <= 0:
		finish_map()
		is_game_over = true

func finish_map() -> void:
	$SpawnerPath/SpawnTimer.stop()
