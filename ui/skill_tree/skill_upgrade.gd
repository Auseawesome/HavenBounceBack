@tool
class_name SkillUpgrade
extends Control

@export
var skill: Skill:
	set(value):
		skill = value
		if is_instance_valid(skill):
			inner_button.icon = skill.icon
		update_size()

var inner_button := Button.new()

func _init() -> void:
	inner_button.set_anchors_preset(PRESET_FULL_RECT)
	inner_button.name = "Skill Button"
	inner_button.expand_icon = true
	add_child(inner_button, false, Node.INTERNAL_MODE_BACK)
	update_size()

func update_size() -> void:
	var icon_size := Vector2.ZERO
	if is_instance_valid(skill):
		icon_size = skill.icon.get_size()
	custom_minimum_size = icon_size * 4 + Vector2(8, 8)
