class_name SkillTree
extends Control

@export
var default_traits: Array[Trait] = []

@export
var skill_tree_contents: Node

@export
var level_enter_button: Button

@export
var skill_title_label: Label

@export
var skill_description_label: Label

@export
var skill_buy_button: Button

@export
var skill_title_container: MarginPreserver

@export
var level_enter_container: MarginPreserver

@export
var skill_information_panel: Panel

var selected_upgrade: SkillUpgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	prepare_traits()
	Globals.skill_tree = self
	level_enter_button.pressed.connect(Globals.enter_level)
	skill_buy_button.pressed.connect(_on_buy_skill_button_pressed)
	
	skill_information_panel.size_flags_stretch_ratio = 0.3 * Globals.main.get_window_scale_needed()
	
	skill_title_container.calc_maximum_size()
	level_enter_container.calc_maximum_size()

func prepare_traits() -> void:
	for default_trait in default_traits:
		Globals.traits[default_trait.id] = default_trait.duplicate()
	iterate_skill_children(skill_tree_contents)

func iterate_skill_children(node: Node) -> void:
	for child in node.get_children():
		iterate_skill_children(child)
		
		if not child is SkillUpgrade:
			continue
		
		child.skill.apply_skill(Globals.traits)

func update_skill_information(upgrade: SkillUpgrade):
	var skill := upgrade.skill
	skill_title_label.text = skill.get_shop_message()
	if upgrade.current_visibility_state >= SkillUpgrade.SkillVisibilityState.NOT_BOUGHT:
		skill_description_label.text = skill.desc
		skill_buy_button.text = "Buy (" + str(skill.cost.get_value()) + ")"
	else:
		skill_description_label.text = "This skill is not unlocked yet, unlock more of it's dependencies first!"
		var completion: float = 0
		for dependency in upgrade.dependencies:
			var prop_completed := dependency.skill.get_proportion_completed()
			var needed_completion := upgrade.dependency_proportion_needed
			if upgrade.all_dependencies_needed:
				completion += clamp(prop_completed / needed_completion, 0, 1)
			else:
				completion = max(completion, prop_completed / needed_completion)
		
		if upgrade.all_dependencies_needed:
				completion /= len(upgrade.dependencies)
		
		skill_buy_button.text = "%1.1f%%" % (completion * 100)
	skill_title_container.calc_maximum_size()
	selected_upgrade = upgrade

func _on_buy_skill_button_pressed() -> void:
	if is_instance_valid(selected_upgrade) and selected_upgrade._on_skill_bought():
		update_skill_information(selected_upgrade)
