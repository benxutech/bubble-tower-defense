extends Node2D

class_name BaseTower

var is_placed = true
var can_place = false
@export var collision_radius = 50.0
@export var attack_range_radius = 100.0
@export var base_attack_cooldown_time_ms: int = 500
@export var base_attack_damage = 1
var attack_range_cast: ShapeCast2D
var can_attack = false
var level = 1

var tower_stats = TowerLevels.new().tower_stats[level - 1]

func _ready() -> void:
	$CooldownTimer.start(tower_stats.base_attack_cooldown_time_ms / 1000) # TODO: this method is not being called. Bug on spawn

func update_tower_stats():
	tower_stats = TowerLevels.new().tower_stats[level - 1]
	$CooldownTimer.wait_time = tower_stats.base_attack_cooldown_time_ms / 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_placed:
		set_collision_status($CollisionArea2D.has_overlapping_areas())
	else:
		attack()

func attack() -> void:
	if can_attack:
		var bubble = get_bubble()
		
		if bubble:
			var direction = (bubble.global_position - global_position).normalized()
			var angle = direction.angle()
			
			bubble.hit(base_attack_damage)
			can_attack = false
			rotation = angle
			
			if not $AnimationPlayer.is_playing():
				$AnimationPlayer.play("attack")
		
func get_bubble() -> BaseBubble:
	if attack_range_cast and attack_range_cast.is_colliding():
		var target = attack_range_cast.get_collider(0)

		if target:
			var is_bubble = target.get_meta("is_bubble", false)
			if is_bubble:
				var area = target as Area2D
				return area.get_parent() as BaseBubble  # Explicitly cast to BaseBubble
			
	return null

func place() -> void:
	add_collision()
	add_range_attack()
	
	is_placed = true

func add_collision() -> void :
	var circle = CircleShape2D.new()
	var collision = CollisionShape2D.new()
	
	circle.radius = collision_radius
	collision.shape = circle
	$CollisionArea2D.add_child(collision)

func add_range_attack() -> void:
	var circle = CircleShape2D.new()
	
	attack_range_cast = ShapeCast2D.new()
	attack_range_cast.collide_with_areas = true
	attack_range_cast.shape = circle
	attack_range_cast.add_exception_rid($CollisionArea2D)
	circle.radius = tower_stats.attack_range_radius
	
	add_child(attack_range_cast)

func set_collision_status(is_colliding: bool):
	# TODO: Should we have a global const for colors?
	var color = Color.RED if is_colliding else Color.GREEN_YELLOW
	
	can_place = is_colliding
	modulate = Color(color) 

func _on_cooldown_timer_timeout() -> void:
	can_attack = true
	
func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.pressed && is_mouse_over():
			print('yep over')
			GlobalSignal.view_tower_data.emit(self)
			
func level_up() -> void:
	if level >= TowerLevels.new().tower_stats.size():
		return
	level += 1
	update_tower_stats()
	print(tower_stats)
	print(level)
	
func is_mouse_over() -> bool:
	var local_mouse_pos = get_local_mouse_position()
	var rect = Rect2(Vector2(48, 48), $Body.texture.get_size())  # Adjust for node size
	print(rect)
	return rect.has_point(local_mouse_pos)
