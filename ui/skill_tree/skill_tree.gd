class_name SkillTree
extends Control

@export
var default_traits: Array[Trait] = []

var traits: Dictionary[String, Trait] = {}

var current_points: int :
	set(value):
		current_points = value
		Globals.skill_points_label.text = "Skill Points: " + str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for default_trait in default_traits:
		traits[default_trait.id] = default_trait
	Globals.skill_tree = self
	$LevelEnterButton.pressed.connect(Globals.enter_level)
