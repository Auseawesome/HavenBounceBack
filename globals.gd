extends Node

var main: Node

var skill_tree: Control
var skill_points_label: Label

var world_scene := preload("res://world/world.tscn")
var world: Node2D

func enter_level() -> void:
	world = world_scene.instantiate()
	main.add_child(world)
	skill_tree.visible = false
	
	world.set_world_height(2592)
