extends RigidBody2D

var clickPos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle_front")

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return;
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return;
	
	if !event.pressed:
		linear_velocity += clickPos - event.global_position
		print(linear_velocity)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return;
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return;
	
	if event.pressed:
		clickPos = event.global_position
		print(clickPos)
