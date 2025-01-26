extends PathFollow2D

class_name BaseBubble

@export var max_health = 1
@export var speed = 0.1
@export var base_damage = 1
@export var color: Color = Color.DARK_TURQUOISE
@export var click_damage = 2
var is_destroyed := false
var current_health = max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = color
	current_health = max_health
	pass

func finish_path():
	if is_destroyed:
		return
	is_destroyed = true
	GlobalSignal.damage_taken.emit(base_damage)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += speed * delta
	
	if progress_ratio >= 1:
		finish_path()
		return

func hit(damage: int) -> void:
	if not is_destroyed:
		current_health -= click_damage
		if current_health <= 0:
			pop()
	

func deal_bubble_click_damage() -> void:
	hit(click_damage)
	
	if current_health > 0:
		if ($HitSound):
			$HitSound.play()
		

# Destroys the bubble
func pop() -> void:
	if not is_destroyed:
		speed = 0
		is_destroyed = true
		$BubbleSprite.play("pop")
		if ($PopSound):
			$PopSound.play()
		GlobalSignal.bubble_popped.emit(max_health)

func _on_animated_sprite_2d_animation_finished():
	if is_destroyed:
		queue_free()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	## TODO: Left and Right click works...
	if event is InputEventMouseButton && event.is_pressed():
		deal_bubble_click_damage()
