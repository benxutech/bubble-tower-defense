extends Node2D

var is_placed = false
var can_place = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not is_placed:
		set_collision_status($CollisionArea.has_overlapping_areas())		
	else:
		print("placed")
		
func set_collision_status(is_colliding: bool):
	# TODO: Should we have a global const for colors?
	var color = "#de1028" if is_colliding else "#2af530"
	
	can_place = is_colliding
	modulate = Color(color) 
