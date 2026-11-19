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
		var centre_pos
		
		var line = Line2D.new()
		line.z_index = -1
		line.points = [size/2, dependency.position - position + dependency.size/2]
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
