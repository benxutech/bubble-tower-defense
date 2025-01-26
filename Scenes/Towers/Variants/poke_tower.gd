extends "res://Scenes/Towers/base_tower.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_placed:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("attack")

func create_projectile():
	var projectileScene := preload("res://Scenes/Towers/Variants/PokeProjectile.tscn")
	var projectile = projectileScene.instantiate()
	projectile.scale = Vector2(2,2)
	projectile.rotation = rotation
	add_child(projectile)
