extends RigidBody2D

var click_listen: bool
var click_held: bool

var remaining_flings: int = 25

var speed_scale_factor: float = 320

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle_front")

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if event.pressed:
		start_fling()
		return
	
	if click_held:
		handle_fling(event.global_position)

func start_fling() -> void:
	if click_listen:
		click_held = true
		$DragMax.visible = true

func handle_fling(mouse_pos: Vector2) -> void:
	$DragMax.visible = false
	
	var fling_vec := global_position - mouse_pos
	var clamped_length := clampf(fling_vec.length() / 316, 0, 1)
	var clamped_fling_vec := fling_vec.normalized() * clamped_length
	
	linear_velocity += clamped_fling_vec * speed_scale_factor
	click_held = false
	remaining_flings -= 1
	$"Control/Label".text = "Flings Remaining: " + str(remaining_flings)
	if remaining_flings < 0:
		Globals.exit_level()

func _on_click_area_enter() -> void:
	click_listen = true

func _on_click_area_exit() -> void:
	click_listen = false

func _on_collision(body: Node) -> void:
	if body is not Obstacle:
		return;
	
	var points_gained = body.on_collision(linear_velocity)
	Globals.skill_tree.current_points += points_gained
