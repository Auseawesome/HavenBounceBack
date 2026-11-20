extends Node

var main: Node

var player: Player

var skill_scene := preload("res://ui/skill_tree/skill_tree.tscn")

var skill_tree: SkillTree
var skill_points_label: Label

var world_scene := preload("res://world/world.tscn")
var world: World

var traits: Dictionary[String, Trait] = {}

var current_points: int = 1000:
	set(value):
		current_points = value
		skill_points_label.text = "Skill Points: " + str(value)

func add_skill_tree() -> void:
	skill_tree = skill_scene.instantiate()
	skill_tree.set_anchors_preset(Control.PRESET_FULL_RECT)
	main.add_child(skill_tree)

func enter_level() -> void:
	Globals.skill_tree.prepare_traits()
	
	world = world_scene.instantiate()
	main.add_child(world)
	skill_tree.queue_free()
	
	world.set_world_height(2592)

func exit_level() -> void:
	world.queue_free()
	add_skill_tree()
	Globals.skill_points_label.position.y = 10
