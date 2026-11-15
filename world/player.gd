class_name Player
extends RigidBody2D

var click_listen: bool
var click_held: bool

var remaining_flings: int = 25

var speed_scale_factor: float = 320
var damage_scale_factor: float = 0.05
var redirection_responsiveness: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player = self
	$AnimatedSprite2D.play("idle_front")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		draw_arrow()
	
	if event is not InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if event.pressed:
		start_fling()
		draw_arrow()
		return
	
	if click_held:
		handle_fling()

func draw_arrow() -> void:
	var angle = (-get_local_mouse_position()).angle()
	
	$ArrowViewer.position = Vector2(160, 0).rotated(angle) - Vector2(128, 128)
	$ArrowViewer/ScaledArrowRenderer/DirectionArrow.rotation = angle

func start_fling() -> void:
	if click_listen:
		click_held = true
		$DragMax.visible = true
		$ArrowViewer.visible = true

func handle_fling() -> void:
	$DragMax.visible = false
	$ArrowViewer.visible = false
	
	var fling_vec := -get_local_mouse_position()
	print(fling_vec)
	var clamped_length := clampf(fling_vec.length() / 316, 0, 1)
	var clamped_fling_vec := fling_vec.normalized() * clamped_length
	var fling_velocity := clamped_fling_vec * speed_scale_factor
	
	# Keep old velocity only if moving in similar direction to new velocity
	# velocity_keep_factor ranges between (1 - redirection_responsiveness) and 1
	var norm_fling := fling_velocity.normalized()
	var norm_velocity := linear_velocity.normalized()
	var velocity_keep_factor := (norm_velocity.dot(norm_fling) - 1) * (redirection_responsiveness) / 2 + 1
	print(velocity_keep_factor)
	linear_velocity = fling_velocity + (velocity_keep_factor * linear_velocity)
	
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
