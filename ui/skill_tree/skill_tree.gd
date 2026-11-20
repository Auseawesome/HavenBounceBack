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

var traits: Dictionary[String, Trait] = {}

var current_points: int :
	set(value):
		current_points = value
		Globals.skill_points_label.text = "Skill Points: " + str(value)

var selected_upgrade: SkillUpgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	prepare_traits()
	Globals.skill_tree = self
	level_enter_button.pressed.connect(Globals.enter_level)
	skill_buy_button.pressed.connect(_on_buy_skill_button_pressed)

func prepare_traits() -> void:
	for default_trait in default_traits:
		traits[default_trait.id] = default_trait.duplicate()
	iterate_skill_children(skill_tree_contents)

func iterate_skill_children(node: Node) -> void:
	for child in node.get_children():
		iterate_skill_children(child)
		
		if not child is SkillUpgrade:
			continue
		
		child.skill.apply_skill(traits)

func update_skill_information(upgrade: SkillUpgrade):
	var skill := upgrade.skill
	skill_title_label.text = skill.get_shop_message()
	skill_description_label.text = skill.desc
	skill_buy_button.text = "Buy (" + str(skill.cost.get_value()) + ")"
	skill_title_container.calc_maximum_size()
	selected_upgrade = upgrade

func _on_buy_skill_button_pressed() -> void:
	if selected_upgrade._on_skill_bought():
		update_skill_information(selected_upgrade)
