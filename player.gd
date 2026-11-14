extends RigidBody2D

var is_clicked: bool
var click_pos: Vector2


@onready
var skill_tree := $"../../SkillTree"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle_front")

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return;
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return;
	
	if !event.pressed && is_clicked:
		linear_velocity += click_pos - event.global_position
		is_clicked = false

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return;
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return;
	
	if event.pressed:
		click_pos = event.global_position
		is_clicked = true
		

func _on_collision(body: Node) -> void:
	if body is not Obstacle:
		return;
	
	var points_gained = body.on_collision(linear_velocity)
	skill_tree.current_points += points_gained
