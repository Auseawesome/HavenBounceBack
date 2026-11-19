class_name Player
extends RigidBody2D

const MAX_ARROW_LENGTH = 52
const VIEWPORT_SIZE = 64
const VIEWPORT_SIZE_VEC = Vector2(VIEWPORT_SIZE, VIEWPORT_SIZE)

@onready var arrow_rotator := $ArrowViewer/ScaledArrowRenderer/ArrowRotator
@onready var direction_arrow := $ArrowViewer/ScaledArrowRenderer/ArrowRotator/DirectionArrow

var click_held: bool

@onready
var traits := Globals.skill_tree.traits

var remaining_flings: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player = self
	$AnimatedSprite2D.play("idle_front")
	remaining_flings = traits.flings.get_value()

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

func get_clamped_fling_length(mouse_pos: Vector2) -> float:
	var fling_vec := -mouse_pos
	return clampf(fling_vec.length() / 316, 0, 1)
	

func draw_arrow() -> void:
	var mouse_pos := get_local_mouse_position()
	
	var arrow_proportion := get_clamped_fling_length(mouse_pos)
	
	# Use proportion of arrow to change length
	var start_point: Vector2 = direction_arrow.points[0]
	start_point.x = (1 - arrow_proportion) * MAX_ARROW_LENGTH
	direction_arrow.set_point_position(0, start_point)
	
	# Calculate angle and offset using arrow length and viewport sizes
	var angle := (-mouse_pos).angle()
	var offset := MAX_ARROW_LENGTH * 4 * arrow_proportion - VIEWPORT_SIZE/2
	
	# Set positions using calculated values
	$ArrowViewer.position = Vector2(offset, 0).rotated(angle) - VIEWPORT_SIZE_VEC*2
	arrow_rotator.rotation = angle

func start_fling() -> void:
	var mousePos = get_local_mouse_position()
	
	if mousePos.length_squared() < 10000:
		click_held = true
		$DragMax.visible = true
		$ArrowViewer.visible = true

func handle_fling() -> void:
	$DragMax.visible = false
	$ArrowViewer.visible = false
	
	var fling_vec := -get_local_mouse_position()
	var clamped_fling_vec := fling_vec.normalized() * get_clamped_fling_length(fling_vec)
	var fling_velocity: Vector2 = clamped_fling_vec * traits.speed.get_value()
	
	# Keep old velocity only if moving in similar direction to new velocity
	# velocity_keep_factor ranges between (1 - redirection_responsiveness) and 1
	var norm_fling := fling_velocity.normalized()
	var norm_velocity := linear_velocity.normalized()
	var redirection_responsiveness: float = traits.redirection_responsiveness.get_value()
	var velocity_keep_factor := (norm_velocity.dot(norm_fling) - 1) * redirection_responsiveness / 2 + 1
	linear_velocity = fling_velocity + (velocity_keep_factor * linear_velocity)
	
	click_held = false
	remaining_flings -= 1
	$"Control/Label".text = "Flings Remaining: " + str(remaining_flings)
	if remaining_flings < 0:
		Globals.exit_level()

func _on_collision(body: Node) -> void:
	linear_velocity *= traits.bounciness.get_value()
	
	if body is not Obstacle:
		return;
	
	var points_gained = body.on_collision(linear_velocity)
	Globals.skill_tree.current_points += points_gained
