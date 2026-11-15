class_name SkillTree
extends Control

var current_points: int :
	set(value):
		current_points = value
		Globals.skill_points_label.text = "Skill Points: " + str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.skill_tree = self
	$LevelEnterButton.pressed.connect(Globals.enter_level)
