extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var min_child_pos := Vector2.ZERO
	var max_child_pos := Vector2.ZERO
	
	for child in get_children():
		if child is not Control:
			continue;
		
		min_child_pos.x = min(min_child_pos.x, child.position.x)
		min_child_pos.y = min(min_child_pos.y, child.position.y)
		
		max_child_pos.x = max(max_child_pos.x, child.position.x + child.size.x)
		max_child_pos.y = max(max_child_pos.y, child.position.y + child.size.y)
	
	for child in get_children():
		if child is not Control:
			continue;
		
		child.position += min_child_pos + Vector2(50, 50)
	
	custom_minimum_size = max_child_pos - min_child_pos + Vector2(100, 100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
