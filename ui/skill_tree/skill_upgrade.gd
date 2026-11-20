@tool
class_name SkillUpgrade
extends Control

signal skill_moved

signal skill_state_changed

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

@export
var all_dependencies_needed: bool

@export
var dependency_proportion_needed: float

enum SkillVisibilityState {
	UNKNOWN = -1,
	HIDDEN,
	SILHOUETTE,
	GREY,
	NOT_BOUGHT,
	REVEALED
}

var current_visibility_state := SkillVisibilityState.UNKNOWN

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

func _ready() -> void:
	if not Engine.is_editor_hint():
		update_visibility()
		for dependency in dependencies:
			dependency.skill_state_changed.connect(update_visibility)

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
	if current_visibility_state <= SkillVisibilityState.SILHOUETTE:
		return
	
	Globals.skill_tree.update_skill_information(self)

func dependencies_satisifed() -> bool:
	if len(dependencies) == 0:
		return true
	
	var valid_dependencies := 0
	for dependency in dependencies:
		var prop := dependency.skill.get_proportion_completed()
		if prop >= dependency_proportion_needed:
			valid_dependencies += 1
	
	if valid_dependencies < 1:
		return false
	
	if not all_dependencies_needed:
		return true
	
	if valid_dependencies == len(dependencies):
		return true
	
	return false

func _on_skill_bought() -> bool:
	if not dependencies_satisifed():
		return false
	
	var cost := skill.cost.get_value()
	
	if cost > Globals.current_points:
		return false
	if not skill.can_upgrade_skill():
		return false
		
	skill.upgrade_skill()
	Globals.current_points -= cost
	skill_state_changed.emit()
	return true

func update_visibility() -> void:
	if current_visibility_state == SkillVisibilityState.REVEALED:
		return
	
	if skill.bought_at_least_once():
		current_visibility_state = SkillVisibilityState.REVEALED
		visible = true
		inner_button.self_modulate = Color.WHITE
		return
	
	if current_visibility_state == SkillVisibilityState.NOT_BOUGHT:
		return
	
	if dependencies_satisifed():
		current_visibility_state = SkillVisibilityState.NOT_BOUGHT
		visible = true
		inner_button.self_modulate = Color.DARK_GRAY
		return
	
	if current_visibility_state == SkillVisibilityState.GREY:
		return
	
	for dependency in dependencies:
		if dependency.current_visibility_state == SkillVisibilityState.UNKNOWN:
			dependency.update_visibility()
		
		var dep_visible := dependency.current_visibility_state >= SkillVisibilityState.NOT_BOUGHT
		if dep_visible:
			current_visibility_state = SkillVisibilityState.GREY
			visible = true
			inner_button.self_modulate = Color(0.25, 0.25, 0.25)
			return
		
		var dep_grey := dependency.current_visibility_state == SkillVisibilityState.GREY
		var not_silhoutte := not current_visibility_state == SkillVisibilityState.SILHOUETTE
		if not_silhoutte and dep_grey:
			current_visibility_state = SkillVisibilityState.SILHOUETTE
			visible = true
			inner_button.self_modulate = Color.BLACK
	
	if current_visibility_state == SkillVisibilityState.SILHOUETTE:
		return
	
	current_visibility_state = SkillVisibilityState.HIDDEN
	visible = false
