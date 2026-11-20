@tool
class_name SkillUpgrade
extends Control

signal skill_moved

@export
var skill: Skill:
	set(value):
		skill = value
		if is_instance_valid(skill):
			inner_button.icon = skill.icon
		update_size()

@export
var dependencies: Array[SkillUpgrade]:
	set(value):
		unbind_dependency_signals(value)
		dependencies = value
		update_dependency_signals()
		update_dependency_lines()

var dependency_lines: Array[Line2D]

var inner_button := Button.new()

func _init() -> void:
	inner_button.set_anchors_preset(PRESET_FULL_RECT)
	inner_button.name = "Skill Button"
	inner_button.expand_icon = true
	inner_button.pressed.connect(_on_button_pressed)
	add_child(inner_button, false, Node.INTERNAL_MODE_BACK)
	update_size()
	
	set_notify_transform(true)

func update_size() -> void:
	var icon_size := Vector2.ZERO
	if is_instance_valid(skill):
		icon_size = skill.icon.get_size()
	custom_minimum_size = icon_size * 4 + Vector2(8, 8)

func update_dependency_lines() -> void:
	for line in dependency_lines:
		if (is_instance_valid(line)):
			line.queue_free()
	
	dependency_lines.resize(dependencies.size())
	
	for i in range(0, len(dependencies)):
		var dependency := dependencies[i]
		if not is_instance_valid(dependency):
			dependency_lines[i] = null
			continue
		
		var line := Line2D.new()
		
		var line_start := size/2
		var line_end := dependency.global_position - global_position + dependency.size/2
		
		var join_vec := line_start - line_end
		var join_angle := join_vec.angle()
		
		var arrow_start := (line_start + line_end + Vector2(16, 0).rotated(join_angle)) / 2
		var arrow_start_offset := arrow_start + Vector2(0.1, 0).rotated(join_angle)
		
		var arrow_top := arrow_start + Vector2(-32, 32).rotated(join_angle)
		var arrow_bottom := arrow_start + Vector2(-32, -32).rotated(join_angle)
		
		line.z_index = -1
		line.points = [
			line_start,
			arrow_start,
			arrow_top,
			arrow_start_offset,
			arrow_bottom,
			arrow_start,
			line_end
		]
		add_child(line, false, Node.INTERNAL_MODE_FRONT)
		
		dependency_lines[i] = line

func unbind_dependency_signals(newDependencies: Array[SkillUpgrade]) -> void:
	for dependency in dependencies:
		if not is_instance_valid(dependency):
			continue
		if newDependencies.has(dependency):
			continue
		if not dependency.skill_moved.is_connected(update_dependency_lines):
			continue
		
		dependency.skill_moved.disconnect(update_dependency_lines)

func update_dependency_signals() -> void:
	for dependency in dependencies:
		if not is_instance_valid(dependency):
			continue
		if dependency.skill_moved.is_connected(update_dependency_lines):
			continue
		
		dependency.skill_moved.connect(update_dependency_lines)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TRANSFORM_CHANGED:
			skill_moved.emit()
			update_dependency_lines()

func _on_button_pressed() -> void:
	Globals.skill_tree.update_skill_information(self)

func _on_skill_bought() -> bool:
	var cost = skill.cost.get_value()
	
	if cost > Globals.skill_tree.current_points:
		return false
	if not skill.can_upgrade_skill():
		return false
		
	skill.upgrade_skill()
	Globals.skill_tree.current_points -= cost
	return true
