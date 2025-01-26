extends Node2D

var is_placed = false
var can_place = false
@export var collision_radius = 50.0
@export var atack_range_radius = 100.0
var attack_range_cast: ShapeCast2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not is_placed:
		$CollisionArea && set_collision_status($CollisionArea.has_overlapping_areas())
	if is_placed:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("attack")
	
		
func _physics_process(_delta: float) -> void:
	if attack_range_cast && attack_range_cast.is_colliding():
		print(attack_range_cast.get_collision_count())
		if attack_range_cast.get_collider(0) is BaseBubble:
			print("it is a bubble")

func place() -> void:
	add_collision()
	add_range_attack()
	is_placed = true

func add_collision() -> void :
	var circle = CircleShape2D.new()
	var collision = CollisionShape2D.new()

	circle.radius = collision_radius
	collision.shape = circle
	add_child(collision)

func add_range_attack() -> void:
	var circle = CircleShape2D.new()
	
	attack_range_cast = ShapeCast2D.new()
	attack_range_cast.collide_with_areas = true
	attack_range_cast.shape = circle
	circle.radius = atack_range_radius
	var collision = $CollisionArea
	if (collision):
		collision.add_child(attack_range_cast)

func set_collision_status(is_colliding: bool):
	# TODO: Should we have a global const for colors?
	var color = Color.RED if is_colliding else Color.GREEN_YELLOW
	
	can_place = is_colliding
	modulate = Color(color) 
	
func create_projectile():
	pass
