@tool
class_name MarginPreserver
extends Control

@export
var preserve_x: bool = true

@export
var preserve_y: bool = true

@export
var margin: Vector2 = Vector2(16, 16)

@export_tool_button("Recalculate Size")
var recalc_size := calc_maximum_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	calc_maximum_size()

func calc_maximum_size() -> void:
	var min_child_pos := Vector2.ZERO
	var max_child_pos := Vector2.ZERO
	
	for child in get_children():
		if child is not Control:
			continue;
		
		min_child_pos.x = min(min_child_pos.x, child.position.x)
		min_child_pos.y = min(min_child_pos.y, child.position.y)
		
		max_child_pos.x = max(max_child_pos.x, child.position.x + child.get_combined_minimum_size().x)
		max_child_pos.y = max(max_child_pos.y, child.position.y + child.get_combined_minimum_size().y)
	
	var target_size := max_child_pos - min_child_pos + margin
	
	var new_min_size := Vector2.ZERO
	if preserve_x:
		new_min_size.x = target_size.x
	if preserve_y:
		new_min_size.y = target_size.y
	
	custom_minimum_size = new_min_size
