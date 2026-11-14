extends RigidBody2D

var click_listen: bool
var is_clicked: bool
var click_pos: Vector2

var remaining_flings: int = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle_front")

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return;
	
	if event.pressed:
		if click_listen:
			click_pos = event.global_position
			is_clicked = true
		
		return
	
	if !is_clicked:
		return
	
	linear_velocity += click_pos - event.global_position
	is_clicked = false
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
